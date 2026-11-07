Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063341;
	b=Pvy462p3GZpXta1vY6P2tv17aUQNPnRCR9o1ng0A9eLFyhXwxqglKT1gKrsNlqmlaz3u
	 zcdv+nyXAP2ux7gMNUwCNf452Hzghwj0A0FsMOlEgcEhlFosAjJFGGYy0ZLnL9pqsWiTD
	 T+o66mXTqS8Mo3UtaAMb91amnHl/kNkGq6VS3VnjNpd6pay//hvaTs8afK1gEQU7Lzfkg
	 brb45T7Df+z7N/MzfV/FOu3fWHMTgfLdv9lbOFajX/GUmv2KlGKSHm65+YmvUK1GQJGA3
	 LErq/g3LqW1On+tJE17Ohl5C1MCPkA4/r7irRFMW9zbVyx4awkI6ch32ZZdew/3Mkfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=15m+uuvM+NVjuHhDV/vwvz38aJqrRuXvqnjSib1rRpg=;
	b=PgPdjbBDIfLD7NSqGg3mvLNaeEKmfWCoWHdIws167epPE3rTVfzRBeaJBLJICPf7dzis
	 56b1K2/7Y6zHU7c6uxX48nYmPTnzzYTbCJ90gceMlbcvt+h4vVrePfdaTTwOHJ/tF9u5E
	 4DFln3W5N9AnA+GODucXVu8CJFCo69qGX0ASDrR29q5uNVmBab4bjjugHpJtDacKxnJti
	 LZT6o5P4JtjrHtqzodqQ6SC+bQTHLMxONoQRdrHWqFPmV7yz81VphAa5EOoMZwO01G8eC
	 iTOChX5VnYzTAo91MgpysxPPfdMIvsKtQzlZQYwe8cACt/xwPkl27NkZT/UrJ/5Bk7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bLEXpdBK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECFE606A32C;
	Sat,  7 Nov 2026 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bLEXpdBK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE7C1F0089F;
	Sat,  7 Nov 2026 14:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063341;
	bh=15m+uuvM+NVjuHhDV/vwvz38aJqrRuXvqnjSib1rRpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLEXpdBKfcSximW4za9n+BLcxiBbURsRG77dAxk+imgiajMqXOGRZ7li9s4yH47rY
	 1LGrS7eifob1eOm4EPKtiYoWLfouDbQ0LZcHJ/b5E4QtDkpCMPjJ4ceSf3xlQrrn0E
	 JIE6Q8y82honyv59NZOLpRcyRXQKCs16X4iOtoQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 516/869] nvmet: fix preempt of another registrant by the reservation holder
Date: Sat,  7 Nov 2026 08:53:18 -0500
Message-ID: <20261107134911.041941371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9ab50f821ad69..0f696840b168b 100644
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



