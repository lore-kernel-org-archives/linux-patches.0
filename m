Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725C63E49FB;
	Tue, 21 Jul 2026 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653619; cv=none; b=bo/Fzp9syeL3KtTDQxcWQg/nhs79tpx9XrwahW8vnMwgwASUzuWjcGGGxxYBknSun5I2sjeyaROKmogykHMPHBORIqX62AwdlL4klswo0J2uC8SDSX13ObabnPuRIMzu7TSX+0F02zpA9nTbXIZSwx9fL6wgKnU+HFuo+eyvsE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653619; c=relaxed/simple;
	bh=lXEnvGbIAGwcXYj8yxLnuXK112rLd7HiFUdrhE1xUk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NywQD8SnRHVlrrwGvOsOptODP/vbR/Wh3lkVCpPguzXLrRZIg0DcFVZz5HEHU/YI5S0BO3acKPVHqAzLyCsVBGzBACoo2KP9PJPiCKZAbhijbhW+E/YL+OTbc1V+pybVB0tQty1fGmyL+MDTJT4sN6OSzvZAX8nDoVaOc434U60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmMbLQan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmMbLQan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF5A1F000E9;
	Tue, 21 Jul 2026 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653618;
	bh=oEIpxZCa7077+bsMpnJqPPP3488DowPxGkTaWTGOdKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmMbLQan7Wx3rX6TbxoO90vcAvOvXS1wVNV8OA9pekdNef7YnVtfT8qeykXFlgz95
	 f2xFyGKHC9nR9XssazO75FarEN6VFPxEtwtTck/xOxADBvm90GaTBME3FuG8IeQr7g
	 Z4xQZ6+tKrBTdx6x9GXb4q0xzrDZ6h1CM03zYL6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1396/2077] netfs: Fix writeback error handling
Date: Tue, 21 Jul 2026 17:17:49 +0200
Message-ID: <20260721152625.737989325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit ac5f95ac5d6d0f4c567b8b642825705a2bf0d79e ]

Fix the error handling in writeback_iter() loop.  If an error occurs,
writeback_iter() needs to be called again with *error set to the error so
that it can clean up iteration state.  Further, the current folio needs
unlocking and redirtying.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Link: https://sashiko.dev/#/patchset/20260619140646.2633762-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-14-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index de7a5684b6091e..cd0c8b3297ee0a 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -588,8 +588,6 @@ int netfs_writepages(struct address_space *mapping,
 		}
 
 		error = netfs_write_folio(wreq, wbc, folio);
-		if (error < 0)
-			break;
 	} while ((folio = writeback_iter(mapping, wbc, folio, &error)));
 
 	netfs_end_issue_write(wreq);
@@ -602,7 +600,14 @@ int netfs_writepages(struct address_space *mapping,
 	return error;
 
 couldnt_start:
-	netfs_kill_dirty_pages(mapping, wbc, folio);
+	if (error == -ENOMEM) {
+		folio_redirty_for_writepage(wbc, folio);
+		folio_unlock(folio);
+		folio = writeback_iter(mapping, wbc, folio, &error);
+		WARN_ON_ONCE(folio != NULL);
+	} else {
+		netfs_kill_dirty_pages(mapping, wbc, folio);
+	}
 out:
 	mutex_unlock(&ictx->wb_lock);
 	_leave(" = %d", error);
-- 
2.53.0



