Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064740;
	b=L4340rE7R/LcQPS7FZt+6Umf/NNYlO1l0GRT22O1wUVTIpVHRhjHpktpbt+jfbGDfTZ2
	 IUIhdxXKhvYWU1AUIwtRXiGBEWUlMk9tyWTAhdD1QUmCrokGijkFodT6jVA7Otc/t1aVk
	 amF0DVhVReXVSDsU+e5f1jCJLxM9HQW8eyg86AJT1PpJe3JTKfRc61YohosUGhh4PE91O
	 M21xxdjUbNpecOAMYDF44uNUfkvehFpayPN0LEg4TEmGnEwDOOQDgRFUYXy9HBM5Wootj
	 bag4UafTdQpuS/O0YsGlFb8KitDYbm69iBBlYBR3dQbxOHWnk2rJkin85WLu61d5ZRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QUmqT3yKPp04nyqmjGBR7zu6nOJ4ZKrqvU76ygCEnbY=;
	b=3d0DENZoY7R25MR6+Y3tqEBp36kL+bBtJ3Dq2ZBvCv1B4at0U9JlNWTd4nW5QINq0XNm
	 GF0MdeJ/IDx0FFxCneB2ak730ks/pUV7H8G9A/8m78UvWbTlLHQzznftgccae4fJWAAXy
	 lFlWoqdAIs5nD9CGahytQuaYbygWQ7M3LtDVHkawC4syVg9QY9QuCykfCkCZRhorHdfEt
	 Rk08QAT8r9cBcohF8HWHGhpFDYaI+Ad/7z9HCorEAB2lLEVnQebzgeJNNNnqzEJfu7A8k
	 dEKqlvj7eRqlRSQ04dCW1ppnTsF3k6zvsbCZMPyiBGPzKE8PIxscycZ2eYqGdiakjSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C14pnd4t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48E5606D820;
	Sat,  7 Nov 2026 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C14pnd4t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E691F008A1;
	Sat,  7 Nov 2026 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064739;
	bh=QUmqT3yKPp04nyqmjGBR7zu6nOJ4ZKrqvU76ygCEnbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C14pnd4tenRd/x50t387cc1ty+lD8uz6iU+2/JHviCHgKCANGkxRS77fk46tReWOg
	 eJ4wPGD6Q80xmsyUz8Iy0Yb2e51tGyZR1vG3tnd7+QX+9IJ86ktTMdo+djD7vOTymP
	 yahJCQmveo/zz0qWyBtLPcvvSvKVHmG7IpImw24I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0708/1257] nvmet: fix preempt of another registrant by the reservation holder
Date: Sat,  7 Nov 2026 08:50:04 -0500
Message-ID: <20261107134958.807440997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit d9e84d4e19994818b80846bd2abb7b396e4116a9 ]

Unless the reservation is of an All Registrants type, nvmet_pr_preempt()
treats every Reservation Acquire command with the Preempt or Preempt and
Abort action that is sent by the reservation holder as the holder
preempting itself.  It updates the reservation type to RTYPE and
completes the command successfully without looking at PRKEY.

NVMe Base Specification 2.1, section 8.1.22.7 makes the action depend
on PRKEY for these reservation types, no matter which registrant sends
the command:

 - PRKEY matches the key of the reservation holder: the reservation is
   preempted.  This is how a holder preempts itself.
 - PRKEY does not match the key of the holder and is not 0h: the
   registrants whose key matches PRKEY are unregistered.
 - PRKEY does not match the key of the holder and is 0h: the command is
   aborted with Invalid Field in Command.

With the current code, a holder that preempts with the key of another
registrant leaves that registrant registered, changes the reservation
type to RTYPE and still gets a successful completion.  With hosts A, B
and C registered with the keys 0xa, 0xb and 0xc, and A holding an
Exclusive Access - Registrants Only reservation, A sends:

  # nvme resv-acquire /dev/nvme1 -n 1 --crkey=0xa --prkey=0xb \
        --rtype=4 --racqa=1
  NVME Reservation Acquire success
  # nvme resv-report /dev/nvme1 -n 1 --eds | grep '^regctl '
  regctl    : 3

and B can still write to the namespace.  Preempt and Abort (--racqa=2)
gives the same result.  When C sends the preempt instead (--crkey=0xc),
B is unregistered and its writes fail with Reservation Conflict.

This defeats fencing in the pNFS SCSI layout server.  nfsd holds the
reservation and fences a client that does not return its layout by
calling pr_preempt() with the key of that client and the abort flag,
which is the command RFC 9561 section 2.2.3 asks for.  On an nvmet
namespace the preempt succeeds, nfsd logs the client as fenced, and the
client keeps writing to the device.  In a test with an nfsd server and
two clients on an nvmet-tcp namespace, the namespace still had three
registrants after the fence and the fenced client went on writing to
it.  With this patch two registrants are left and the writes of the
fenced client fail with a reservation conflict.

Take the self preempt path only when PRKEY is the key of the holder.
Any other PRKEY sent by the holder is then handled by the code that
already serves a non-holder registrant, for Preempt and for Preempt and
Abort.  For a host that holds the reservation this changes the
following:

 - A preempt with the key of another registrant unregisters the
   registrants with that key, sends them the registration preempted
   notification and leaves the reservation type alone.
 - A preempt with PRKEY 0h fails with Invalid Field in Command.  A
   holder that changed its reservation type this way has to pass its
   own key in PRKEY, which works with and without this patch.
 - A preempt with a PRKEY that matches no registrant fails with
   Reservation Conflict.  The specification defines that status only
   for the All Registrants types.  It is what nvmet already returns to
   a non-holder registrant in this case and what the SCSI target
   returns for an unregistered key.  nfsd treats it as a successful
   fence.

Not changed: when the holder preempts itself, registrants that share
its key stay registered.

Fixes: 5a47c2080a73 ("nvmet: support reservation feature")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/pr.c b/drivers/nvme/target/pr.c
index ad13a93afb782..14eaa99f98fa3 100644
--- a/drivers/nvme/target/pr.c
+++ b/drivers/nvme/target/pr.c
@@ -589,7 +589,7 @@ static u16 nvmet_pr_preempt(struct nvmet_req *req,
 				&ctrl->hostid, abort);
 	}
 
-	if (holder == reg) {
+	if (holder == reg && prkey == holder->rkey) {
 		status = nvmet_pr_update_reg_attr(pr, holder,
 				nvmet_pr_update_holder_rtype, &rtype);
 		if (!status && original_rtype != rtype)
-- 
2.53.0



