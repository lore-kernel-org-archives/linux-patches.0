Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117B122259A;
	Mon,  2 Jun 2025 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874471; cv=none; b=ui3UvZinfLw3DQ3Wy2CTXvVi37c9GcRUNKFfCLvx2bYmUh6w6p9iQAExXAWWAcTPnYEKkbB1RBWg7AHAwlOOw+TurH3GT+6Q2l6zgWepD1Xof/frpBcuDT/lKgD5eQY3sJF4RjKzVnWOqwrX7DxmD74nty/AWp4M+/JxOz8g7TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874471; c=relaxed/simple;
	bh=lCyrTtxCHY/wdr4+1WjL1/xz3kG67B3Nep8yJwBtQW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5sLFxt/4PQmd08b6imS1EFKrUEqMsQ3Ef2ytGtK0Ar09UyCvIIFsbKyvSIRlkfn6ihj6LJmlfpl0lUD+kuMUHIti/3HjUbIkfrT6XHC3rLJQtLOwmWMJEtojUTWcWueP6HuUHw9yWppNe6MR07JlgCr9+KuEkbCb0E/y3wC5hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNgiAlth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNgiAlth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B42AC4CEEB;
	Mon,  2 Jun 2025 14:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874470;
	bh=lCyrTtxCHY/wdr4+1WjL1/xz3kG67B3Nep8yJwBtQW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNgiAlthSeLZeCUVOaXTKsj3LGblnMpZ3RieUiepoEOZ+ZImZjzvTUfcxtZv8FJTL
	 bZw1c3tqGHBLuCB86wsCmhMnGO4JzJpjlvk7aMzJkiXUc3Zra4iCQFcMAjAUdp/Bch
	 ukHx+Cl7eWyTPCLU7EAV9PAmDqXStZgvtidPWpDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.4 007/204] dm-integrity: fix a warning on invalid table line
Date: Mon,  2 Jun 2025 15:45:40 +0200
Message-ID: <20250602134255.762726380@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0a533c3e4246c29d502a7e0fba0e86d80a906b04 upstream.

If we use the 'B' mode and we have an invalit table line,
cancel_delayed_work_sync would trigger a warning. This commit avoids the
warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4199,7 +4199,7 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
-	if (ic->mode == 'B')
+	if (ic->mode == 'B' && ic->bitmap_flush_work.work.func)
 		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);


