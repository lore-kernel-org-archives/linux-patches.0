Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704697;
	b=2oucLBE/SV4X9I8t0ytMBT5+UAhJXauAUWGIsgF5A9auKwbaJ4Y151+PqNUG+sn9gEdF
	 PmHYugXJMntWiwRtWWmkjQw+CqoOYFsS2EZ4tOwv1DhYgjcp1QUda3LwD4Rp+JWT2PvfM
	 TTMfwqzxA/ICPST3Yq8rzfd9hWvchhQvZjoEGdPoYsalaHYphC5ydjithtfm67f3wc29N
	 w4eBAnokc7I32DiI1XfUl4nWTzMFzuwMpXpBeY9sZTYTa9BhMYxkeqzgMpGzGYgZc1kNW
	 Lr7/vKYSSjJzk5csJ/EJc9D98mYNtDzXS9gVn/60NiMeklJLLXSLqpiLE/euScBhTsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BrUFcv1i54kx6vvQg31C2a2bA7laT+Uy+A1uvlGuxK0=;
	b=cxqsmV9c6OCN4MBIQaidiFQpPQn2ihfTCbMK55Ss8bXYoQ/sBkY4XFo2AivkbrZhrqGf
	 zyQVTBZLXQOTio3YMBMKa2N/BEVKvNE8F++63RIf1rfeeTB8qs65xI3vwSahvcmWNz4yc
	 UunR9vTQsYcnGrYS298+QkPPkGRrjf5dZlr7YAs/WbBMJgesBcUPD4Y0Y1uV5y4PQej3i
	 RjLk1YaiBUmGOCamqRP3gEmfm+naTMl2v0MbP50WigI9u+F+A/DXQOEIDhWMbUqmpM6D3
	 FtkD65BapLp9pPGP+Dyy2kuqzT73z2ML7st9VMpPI7+GheOMD/Rw4VeN/RHba6knsEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LH88Jddz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC991606A31C;
	Thu, 26 Nov 2026 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LH88Jddz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D301F000C6;
	Thu, 26 Nov 2026 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704697;
	bh=BrUFcv1i54kx6vvQg31C2a2bA7laT+Uy+A1uvlGuxK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LH88Jddzkl9+z8jipCbOIS0gAzwfi9syYh9C5aYjwjzSfcnRgOgvhPJwuIZQWp39+
	 erQeH+AUaevOA7pl8Ln2UAbe7bYocw82TTqfiF+q0plEh4zBgdzcfoCj3wRFK721F0
	 ykUG2gmwFRQkSzVU8spnduX7yl+NAGeyRXlM7OWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 213/265] dm-thin: fix leak if __set_snapshot_details fails
Date: Thu, 26 Nov 2026 15:39:03 +0100
Message-ID: <20261126143620.123090266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit dfb95816cf6f2f2660af2ec64c65dc204c60b5e7 upstream.

If __set_snapshot_details fails, the variable td is leaked - this
prevents any other snapshot with the same id from being created.

Fix this by removing it from the list and freeing it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1180,10 +1180,13 @@ static int __create_snap(struct dm_pool_
 	__close_device(td);
 
 	if (r)
-		goto bad;
+		goto bad2;
 
 	return 0;
 
+bad2:
+	list_del(&td->list);
+	kfree(td);
 bad:
 	dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
 	dm_btree_remove(&pmd->details_info, pmd->details_root,


