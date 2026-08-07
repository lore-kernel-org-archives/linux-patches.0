Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895D929AB1A;
	Fri,  7 Aug 2026 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116652; cv=none; b=ITkB3EE/MMs/gpKsr8GO5a8iQh8DvvOIU9pHE8j2Z/S3CzEgnQgvVt5YFPw1oF7CTeUau/qptOuDoVbVTOCPcAqajSHjjp4VijR1cfsKOmisfRT0N7BxmY3yQF1jrX0LEwoVqE3RBIqtrY6UOVvJcqrqgQo4GHaTIEQkeHj90O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116652; c=relaxed/simple;
	bh=bt6vR2mJkjcSP80IzOHoYZIK6mL4YTDtGtBZeb+tjM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S+MlqG6mBQzqLuAUz3zVMFA1dQCri2ZJw48MICHGimf6VQfbo0OmclIbtG3bQWdV8/hci/lt/DwurmM7Q8NA67LijOBKPpMdti0sfYdTIXuLISdVwPj+H5Y3nIORJoH88KpNBmZ+hxVXPG7CTGIw14+VA4KykrjSGwu6XXoGUuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSABv6kR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSABv6kR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52951F000E9;
	Fri,  7 Aug 2026 15:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116651;
	bh=7oX7xt3hNmeQpSn7CGRLL5aktO4ZdKJj4szQRftl6Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSABv6kRBxoHeMrhL6PHm/Jcsgk71iEIBRw1N6NZBhehrKEn9j/ItoFQA6qeZ7ko2
	 UObz2LnZPNd9u8I/fkuKaLvl0YRIv7q1tizsY8aexL+zEa6GKBF7Cnmxa9KlEetCaa
	 McB7cCviclFXtVZj7Dwnuh4NaV80n1YFdC8WAQ5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 043/438] mshv: Fix duplicate GSI detection for GSI 0
Date: Fri,  7 Aug 2026 16:33:59 +0200
Message-ID: <20260807143428.917672558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit 649dd135491945afa544351e3e6d4a727de87020 ]

The duplicate routing entry check in mshv_update_routing_table() uses
guest_irq_num != 0 to detect whether a GSI slot is already occupied.
This fails for GSI 0 because its guest_irq_num is 0 both when the slot
is unused (zero-initialized) and when legitimately assigned. As a
result, duplicate entries for GSI 0 are silently accepted, with the
second entry overwriting the first — corrupting the routing table
without any error reported to userspace.

While GSI 0 (legacy timer) is unlikely to appear in MSI-based routing
in practice, the check is semantically wrong — it conflates
"uninitialized" with "GSI number 0." Use girq_entry_valid instead,
which is explicitly set to true when an entry is populated and remains
zero for unused slots regardless of the GSI number.

Fixes: 621191d709b14 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/mshv_irq.c b/drivers/hv/mshv_irq.c
index b3142c84dcbc2..65a4ffc82d566 100644
--- a/drivers/hv/mshv_irq.c
+++ b/drivers/hv/mshv_irq.c
@@ -51,7 +51,7 @@ int mshv_update_routing_table(struct mshv_partition *partition,
 		/*
 		 * Allow only one to one mapping between GSI and MSI routing.
 		 */
-		if (girq->guest_irq_num != 0) {
+		if (girq->girq_entry_valid) {
 			r = -EINVAL;
 			goto out;
 		}
-- 
2.53.0



