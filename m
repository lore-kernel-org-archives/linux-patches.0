Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AA422301;
	Thu, 16 Jul 2026 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210092; cv=none; b=YrSIzOHRFZM552mZNTwPF01qzN+HcKPSl6VefvWzY1f6NnNnIPl6/99FLgzjcIjuo9jzrSKqjaEVu5LHW5w3qr/fvxIifJFUNrhOzgEZdWXa4obsiPGjJxgfwcfFMKPA+/I9FwRKl8a3WiAatKlKFOTO64a/DDB8xNPzNjcZU0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210092; c=relaxed/simple;
	bh=kILY9GqYCpu1shXtCf80fXpG+F/qb2H8epaY+GYvNGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5MTiFvn8ed857U1hdP/QtqD1Nfk5p7GGZ10vqSJDEXBrGkTtvrc0T4/EpLhpXvdKtAzhlF4ogadC0gS+RBVkuwjJPeccaWh+u9O5LPPZD7UoyE4V4kqY4OZBujbWMJ0vvXPJBDoL+yQ5S7hZF7Z397MvPTTkvpVFCBG2ACXGTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hh/i4owW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hh/i4owW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FAF1F000E9;
	Thu, 16 Jul 2026 13:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210090;
	bh=eVwMqd+2Ios0/liRCeTrIJQM/jBhFIobEChmu//c+g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hh/i4owWvahWwDTMayrGqn9mlZlccyZRmgQ7wDt3uC5xnjAdqi3X1d2RtAd+de8cB
	 KTNLEn+s1o8aP2Cv/sJhun/cumJEq1Gw5RqT73RGiO2TZeOn66ZkuKOCDhIpjGXkyy
	 L7UHzMkLIH9EW2KA4K3xxuTDpeyKYSr+7/ki46Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Aizen <kai.aizen.dev@gmail.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 433/518] iommufd: Use sizeof(*hdr) instead of sizeof(hdr) in veventq read
Date: Thu, 16 Jul 2026 15:31:41 +0200
Message-ID: <20260716133057.318276689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Kai Aizen <kai.aizen.dev@gmail.com>

commit be93d186ae88a92e7aa77e122d4e661fa57b1e39 upstream.

The bound-check in iommufd_veventq_fops_read() for the normal vEVENT
path uses sizeof(hdr) where the surrounding code uses sizeof(*hdr):

	if (!vevent_for_lost_events_header(cur) &&
	    sizeof(hdr) + cur->data_len > count - done) {

hdr is declared as struct iommufd_vevent_header *, so sizeof(hdr)
evaluates to the size of the pointer.  Surrounding code uses
sizeof(*hdr) consistently:

	if (done >= count || sizeof(*hdr) > count - done) {
	...
	if (copy_to_user(buf + done, hdr, sizeof(*hdr))) {
	...
	done += sizeof(*hdr);

struct iommufd_vevent_header is currently 8 bytes (two __u32 fields,
flags and sequence), so on 64-bit (sizeof(void *) == 8) the two
expressions happen to be equal and the check works as intended.

On 32-bit (sizeof(void *) == 4) the check under-counts the header by
4 bytes: a vEVENT whose data_len causes 8 + cur->data_len to exceed
count - done while 4 + cur->data_len does not will pass the check,
then the loop will copy_to_user 8 bytes of header followed by data_len
bytes of payload, writing past the user-supplied buffer.

It is also a latent bug for any future expansion of struct
iommufd_vevent_header beyond sizeof(void *) on 64-bit; the check
should not depend on the type happening to match the host pointer
width.

Use sizeof(*hdr) to match the rest of the function and the actual
amount that will be copied.

Fixes: e36ba5ab808e ("iommufd: Add IOMMUFD_OBJ_VEVENTQ and IOMMUFD_CMD_VEVENTQ_ALLOC")
Link: https://patch.msgid.link/r/20260430175630.67078-1-kai.aizen.dev@gmail.com
Cc: stable@vger.kernel.org
Reported-by: Kai Aizen <kai.aizen.dev@gmail.com>
Signed-off-by: Kai Aizen <kai.aizen.dev@gmail.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -321,7 +321,7 @@ static ssize_t iommufd_veventq_fops_read
 
 		/* If being a normal vEVENT, validate against the full size */
 		if (!vevent_for_lost_events_header(cur) &&
-		    sizeof(hdr) + cur->data_len > count - done) {
+		    sizeof(*hdr) + cur->data_len > count - done) {
 			iommufd_veventq_deliver_restore(veventq, cur);
 			break;
 		}


