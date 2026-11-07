Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065310;
	b=w5IcJ1ID62Acul4aIO5RLbpo8rqkyTGLnCJCU/b+38uTubEyOD4f8KoFS928qAs87X1H
	 keYDL2wp2Ig+dUn2sbQmlEvKs0LwcOIY7IGbNdzSTwdSBxF5bhSrq9PHthGEQpGupTRyW
	 rixFoAWbj2QVQeh7yblznhQ4EIlGItZ2RAM1BSeVZDO63j8+mr4NBMHrSNX/Y9Ra680Rq
	 VBu5QuvAnzToM0lDUNA1WCAIurn4e+KUUuUqn6TeM0IlWDWR/JP3L4LBDsyaQ+wbVQCpK
	 VrACMI8skrAu3GDwsF4iv0cbxKSf1jRz9AeevrJqvG7q0/IQPYaiJZjTEQXQEdF/55g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OoOGh+btoPjftWghASfdb4FgKzB+uD5tt4ZQid7X4+A=;
	b=dW+5hM/dqtYuYEq9AuU6CErBR7ZTcmnC4d8I+C3vbLZa+P/mZKapEEmXrnpHaGRsEU+z
	 LsJ21Sv3dhFFjrOfW8157DKzp7Ye/Eoz68tJd6/udhwEKMY93MSQ7B7DmUX/4I9P6Paqt
	 giS6HT2uy22InilYq6pAA1daWhB7IdXVtmobySpAN1wlpUcNISmkoSuYZOQI+csBJhLjO
	 LzXXkdxy49j3xfEZENHCj9DoqDR0asOBX4NDqyu7erGglifQLL/fHGAjS+oAwhR65yIqj
	 SaGWTATt6dhtOHE566aCVbNqWYjVrNj0TrB3X7V02r+uPLCOUUyihz1bF/cMj3MnGVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwfKUw55;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF75C606A32C;
	Sat,  7 Nov 2026 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwfKUw55
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832631F0089F;
	Sat,  7 Nov 2026 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065309;
	bh=OoOGh+btoPjftWghASfdb4FgKzB+uD5tt4ZQid7X4+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwfKUw558nQ5yVHZxH6elbMEaG1qwVbdALrQMQHW1Fohx27OG8mcdkjDCLu2sH8TG
	 GHTdiBdEjL7JEOJiEGCkeglXFcPYZE4qd/dr39Iwtqy31pNGuclZck0N69aTefMZNv
	 RFvWZRm7Q3Eyx0Erej2TQVj6fOH5i59lLSiHxqR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.cmo>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1060/1257] scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
Date: Sat,  7 Nov 2026 08:55:56 -0500
Message-ID: <20261107135008.561436675@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 3a7e551ae4bcc53f271fc15ab8e930598e28dad8 ]

In SDB mode, a command that times out during a power management operation
can be released twice:

 1. The command times out while its normal completion is running.

 2. The completion path clears BIT(rq->tag) in hba->outstanding_reqs and
    releases the command. It has not called scsi_done() yet, so
    SCMD_STATE_COMPLETE is still clear.

 3. ufshcd_eh_timed_out() recovers the link, sees SCMD_STATE_COMPLETE
    clear, clears BIT(rq->tag) in hba->outstanding_reqs without checking
    whether it was still set, and releases the same command a second time.

Return SCSI_EH_DONE when ufshcd_clear_outstanding_reqs() returns 0, as
another path has already claimed the command.

Fixes: 01d5e237b339 ("scsi: ufs: core: Handle PM commands timeout before SCSI EH")
Cc: stable@vger.kernel.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.cmo>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261022034443.3034432-5-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d6c082b096796..974bdadcff28e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9606,12 +9606,10 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	 */
 	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
 		if (!hba->mcq_enabled) {
-			unsigned long flags;
 			struct request *rq = scsi_cmd_to_rq(scmd);
 
-			spin_lock_irqsave(&hba->outstanding_lock, flags);
-			__clear_bit(rq->tag, &hba->outstanding_reqs);
-			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+			if (!ufshcd_clear_outstanding_reqs(hba, BIT(rq->tag)))
+				return SCSI_EH_DONE;
 		}
 
 		if (ufshcd_is_scsi_cmd(scmd)) {
-- 
2.53.0



