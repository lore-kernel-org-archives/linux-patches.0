Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E8870838;
	Mon, 23 Jun 2025 21:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713029; cv=none; b=BhlQvZ+fE24nX/s7e60DNKyhOQwMxWk+bOyqgOQg2kH7M95Zi3UVnOyQFdzwiS//LVzV7cwDw/taj9qs4e0oiF1ChPPVYFyXgG1inh9u/uTOu/iUYfKFh8KE/W3PiYhrdFDzQ7q4JKtTtkYzzqWDoDe0/RIPN0gsiSesnPDyNGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713029; c=relaxed/simple;
	bh=IhuCOwyjFcwVRj1sg6TM84wAU/3euGhUOK55GhhLSrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eXG1AQXBuQScofHQe+hLjcJmTvOj4l3YyOWkgcEmMR+1//KPOpl5i1SFeRnIF/HQSceLiDJ0ojtdCP+ENR+VivVi/PDGJxw5i9eZBglPA+qK4NQM0ffmoepw5WCZbib12gqPhFBNhWWseZhuCnoxF5amJnuskP7PprjywArvW+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w94YJD8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w94YJD8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6AFC4CEEA;
	Mon, 23 Jun 2025 21:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713029;
	bh=IhuCOwyjFcwVRj1sg6TM84wAU/3euGhUOK55GhhLSrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w94YJD8JE4IVRjONp733djFSSsQ6ang8mCjywv/N2AzG9QO4s9o094OEky4ZEgMWe
	 kwQs/u8/56Quc4SDF3dR5w4SBX9qSSs5s3s5TdwqsGWwhwVZVjHLl+s+bBmMwgXg55
	 XjnRPHbcZ0LIq3W1z+eL1ZSMCGJDHqyHTYuXp/TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 184/222] platform/x86: dell_rbu: Stop overwriting data buffer
Date: Mon, 23 Jun 2025 15:08:39 +0200
Message-ID: <20250623130617.702715923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3691391fea6b1..16e4614ad3e47 100644
--- a/drivers/platform/x86/dell_rbu.c
+++ b/drivers/platform/x86/dell_rbu.c
@@ -344,7 +344,7 @@ static void packet_empty_list(void)
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



