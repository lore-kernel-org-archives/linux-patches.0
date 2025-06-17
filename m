Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A998FCA4B;
	Tue, 17 Jun 2025 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179503; cv=none; b=o5C43YwdHQLkQuvXXZ7FQ8OAcV30hTWCDx6RU4F24yzHv63cjOIZvxFc4VS+tHspJwJrBCjbHntRqhQG4QCjhi4KRhh8+yV2Au/l0lGDxtKNd09HDeSgbCkrPjPDMKKX/QKgsTydKml4PcrGKAB0zKt/uHNOVl0BcJY/+HKRt+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179503; c=relaxed/simple;
	bh=DhwpuEcw4ESAC3FInCcAjnaO64aqYstCFvDXiRzZsuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpCS4zKGMlUccn8W0fJltEnJb1iY8cHibsQazCgrJ8/Mw2zL8ASg6LrMrMqV5rUusc8v/p4aI9hWcHyp9kaj2kfuVx6SiK3ntxrHZ+AHSyVPwTo9HwGEOd43U2L0UwktgkmbLXMhe99C74ZM4gc19zL69fPP2tkC4h4Yx6Qm85w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ya2cHUSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ya2cHUSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1493C4CEE3;
	Tue, 17 Jun 2025 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179503;
	bh=DhwpuEcw4ESAC3FInCcAjnaO64aqYstCFvDXiRzZsuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ya2cHUScEoosmFzusIe9PF1bwrfojKycniLVg6IbOHFszs0u70ccfc3D5fX1M0HKV
	 MePjq0j52K3YjV4IdvpMv2Vfhg5DteOK7T47Ni8OohNWnfaAj/rncEtUHvJHd2of7I
	 eO1Mx2Jxlpz8Su84ejLDqqE5cxKEidrZpLdzIu94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 764/780] mm/filemap: gate dropbehind invalidate on folio !dirty && !writeback
Date: Tue, 17 Jun 2025 17:27:52 +0200
Message-ID: <20250617152522.630684966@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 095f627add86a6ddda2c2cfd563b0ee05d0172b2 upstream.

It's possible for the folio to either get marked for writeback or
redirtied. Add a helper, filemap_end_dropbehind(), which guards the
folio_unmap_invalidate() call behind check for the folio being both
non-dirty and not under writeback AFTER the folio lock has been
acquired. Use this helper folio_end_dropbehind_write().

Cc: stable@vger.kernel.org
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
Link: https://lore.kernel.org/linux-fsdevel/20250525083209.GS2023217@ZenIV/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/20250527133255.452431-2-axboe@kernel.dk
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1589,6 +1589,16 @@ int folio_wait_private_2_killable(struct
 }
 EXPORT_SYMBOL(folio_wait_private_2_killable);
 
+static void filemap_end_dropbehind(struct folio *folio)
+{
+	struct address_space *mapping = folio->mapping;
+
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
+	if (mapping && !folio_test_writeback(folio) && !folio_test_dirty(folio))
+		folio_unmap_invalidate(mapping, folio, 0);
+}
+
 /*
  * If folio was marked as dropbehind, then pages should be dropped when writeback
  * completes. Do that now. If we fail, it's likely because of a big folio -
@@ -1604,8 +1614,7 @@ static void folio_end_dropbehind_write(s
 	 * invalidation in that case.
 	 */
 	if (in_task() && folio_trylock(folio)) {
-		if (folio->mapping)
-			folio_unmap_invalidate(folio->mapping, folio, 0);
+		filemap_end_dropbehind(folio);
 		folio_unlock(folio);
 	}
 }


