Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE37223DE1;
	Mon, 23 Jun 2025 21:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715198; cv=none; b=FrrBTh1h4oHWEueB09PSMtiiUHWIv0XUFegXj3BDo2bqoVoNgK44sdieP9uTvZEEY5ipHe4zYag/KVA8e/RQ6hXkuXiXivy8bF1Bkl7umBCOWz420MSGu//5VHZb/latncy0Dx3EjsyavBOGFKDyb1DXlMzoPP2129G/RBeUPGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715198; c=relaxed/simple;
	bh=dzYwy+PAfT/ydxk92fBLqik2ko7PzSQqYqvgYeTh1W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uOJ/dMRjcM3aeNwqOORW+8NdN+38tOnjVMnvBz9a0nVpJOoylWdOT9KRo0EbBguGWjwkPkYBLJlfJkEVH1kLiNER8jauoF2sCbXxeooZIXRDqwoDXb7pMo/rrscTqUcGlKytMktAj2MCCsB7d1sw5SM6M4lBEwn0ZrslZOGhosw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kA76k16G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kA76k16G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9DBC4CEEA;
	Mon, 23 Jun 2025 21:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715198;
	bh=dzYwy+PAfT/ydxk92fBLqik2ko7PzSQqYqvgYeTh1W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kA76k16G8zW8p4qx9KLvDVrYmpOtz0t3kEmJ+S4fcZIqJaW6kU7hQdIq9xnim8Z+b
	 zNbCoWtnqoFjOfs+CKaVKvjljZDMxUWmToq3MQw8pBScZ8eRIuK6N5ULZM7KSCR+jL
	 /iz81l1mMdzvUGthToy91ROLC19wIijp4MQ2uVug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/355] platform/x86: dell_rbu: Stop overwriting data buffer
Date: Mon, 23 Jun 2025 15:08:02 +0200
Message-ID: <20250623130635.228229407@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayes <stuart.w.hayes@gmail.com>

[ Upstream commit f4b0fa38d5fefe9aed6ed831f3bd3538c168ee19 ]

The dell_rbu driver will use memset() to clear the data held by each
packet when it is no longer needed (when the driver is unloaded, the
packet size is changed, etc).

The amount of memory that is cleared (before this patch) is the normal
packet size. However, the last packet in the list may be smaller.

Fix this to only clear the memory actually used by each packet, to prevent
it from writing past the end of data buffer.

Because the packet data buffers are allocated with __get_free_pages() (in
page-sized increments), this bug could only result in a buffer being
overwritten when a packet size larger than one page is used. The only user
of the dell_rbu module should be the Dell BIOS update program, which uses
a packet size of 4096, so no issues should be seen without the patch, it
just blocks the possiblity.

Fixes: 6c54c28e69f2 ("[PATCH] dell_rbu: new Dell BIOS update driver")
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Link: https://lore.kernel.org/r/20250609184659.7210-5-stuart.w.hayes@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell_rbu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell_rbu.c b/drivers/platform/x86/dell_rbu.c
index 0b5c1a0260b7a..68a860a97f319 100644
--- a/drivers/platform/x86/dell_rbu.c
+++ b/drivers/platform/x86/dell_rbu.c
@@ -322,7 +322,7 @@ static void packet_empty_list(void)
 		 * zero out the RBU packet memory before freeing
 		 * to make sure there are no stale RBU packets left in memory
 		 */
-		memset(newpacket->data, 0, rbu_data.packetsize);
+		memset(newpacket->data, 0, newpacket->length);
 		set_memory_wb((unsigned long)newpacket->data,
 			1 << newpacket->ordernum);
 		free_pages((unsigned long) newpacket->data,
-- 
2.39.5



