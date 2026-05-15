Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881B73B19DE;
	Fri, 15 May 2026 16:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861832; cv=none; b=LjiDRuuM4xygSfxgm6+FmXgpUYkBDjX4LLlpFaXvPmdCaTfTRENLRmb1ZN1/vwuKHKZp9ZU7yjM65ZVUGbQosbRyghZzPibd7yaYBvPeNyaRYJ/ZnHyg/EOtK7rzSuaWjtvEflGljiMFQozVvf1WAwhVakn/5PBbx1pqprILAQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861832; c=relaxed/simple;
	bh=GEOLVkDE9tqfZVjwSnD/ch6Zfv8Kj1hCGCXYMG5gC/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huaPbCMEwrNCuPjOAJFV9VslOz2HmfVbFw8zfxRPOMWN4QlP5xX9UKwDHbS/OjHFmFN90cPdfsWHPdkSwUxyWD/d1qUaGRmM5N2T5kSdz0Qxhy+V+yEBjVOdn6LdETs7xPKV0XfxxOVwtS7sgBQCDvVf5yAvXd4CeYTWWjwSW0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kvj0G33W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kvj0G33W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C01C2BCB0;
	Fri, 15 May 2026 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861832;
	bh=GEOLVkDE9tqfZVjwSnD/ch6Zfv8Kj1hCGCXYMG5gC/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kvj0G33WJ5cY/+pfGNzK3iHhGFMa/yfxCZH85CzdDSjByxUWY1SzSi8CZlMlgDZ+W
	 ZqjIhlKCESXIedBdSolUtBQ/x1DIQhUXu2bLi+XZP3uZEcoHnmmsRxwi85TyBe3jwr
	 nTTUJGldmAayV475jYcWsTmh3QhHIbF8RW63aBZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH 6.6 473/474] Bluetooth: MGMT: Fix dangling pointer on mgmt_add_adv_patterns_monitor_complete
Date: Fri, 15 May 2026 17:49:42 +0200
Message-ID: <20260515154725.341325901@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 5f5fa4cd35f707344f65ce9e225b6528691dbbaa upstream.

This fixes the condition checking so mgmt_pending_valid is executed
whenever status != -ECANCELED otherwise calling mgmt_pending_free(cmd)
would kfree(cmd) without unlinking it from the list first, leaving a
dangling pointer. Any subsequent list traversal (e.g.,
mgmt_pending_foreach during __mgmt_power_off, or another
mgmt_pending_valid call) would dereference freed memory.

Link: https://lore.kernel.org/linux-bluetooth/20260315132013.75ab40c5@kernel.org/T/#m1418f9c82eeff8510c1beaa21cf53af20db96c06
Fixes: 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5332,7 +5332,7 @@ static void mgmt_add_adv_patterns_monito
 	 * hci_adv_monitors_clear is about to be called which will take care of
 	 * freeing the adv_monitor instances.
 	 */
-	if (status == -ECANCELED && !mgmt_pending_valid(hdev, cmd))
+	if (status == -ECANCELED || !mgmt_pending_valid(hdev, cmd))
 		return;
 
 	monitor = cmd->user_data;


