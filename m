Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793642139D2;
	Thu, 12 Dec 2024 16:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021326; cv=none; b=c45XESBIEDvGMQ3DXtxK+ObmxMzVT4GY/Mpet+cQS2Se99dxPk70VPboyQrHWc/XeQ1xjrM1Gv9NN05ZgYp8dnwtvMVnXxUJc6caZ0bpxyPmqzWFDjtXCLX+Bz16x4+C/MnzahOklm0/OjhfrGABAIt2ctgFQEPV8HnpBjYPqpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021326; c=relaxed/simple;
	bh=z7q2JPOtC/XlFpViS5O9QqoPxUfSVDhktvu2BEp/AXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5KWjHfZb3jAZWbR75lAqP6xsfXqAOuuyJu8hZ46AwENfnN54o1sIOnmamNAVSYHcAonNGDTH4wBNwbQEbBy1cAeUw3wKDy+BARxlyZq8KtTxgNznz10kEeXFV5G962GrudL/IZbVeSkD5eO1wD9j6BgX2/Wt52xDD59n8Bojbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qf1lX7eT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qf1lX7eT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C81C4CECE;
	Thu, 12 Dec 2024 16:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021326;
	bh=z7q2JPOtC/XlFpViS5O9QqoPxUfSVDhktvu2BEp/AXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qf1lX7eTcJ/fwlnRo0WFlnbYqV7G3sT4nlKR+Q/KMB/Vo59OW7gDyAU1GT9IRMhII
	 1LKQi0AwfUYNqZYQj8WrH4imrR/ByUIh+JFaFMCIJ9wjZXBWc/LI4IOIz6BrXg/bTq
	 UdHBo/dHZM11q95tqiPIX3eyNHIkEJKNvFlcyzUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 707/772] scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset
Date: Thu, 12 Dec 2024 16:00:52 +0100
Message-ID: <20241212144419.113793110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit 0b120edb37dc9dd8ca82893d386922eb6b16f860 ]

Most drives rewind the tape when the device is reset. Reading and writing
are not allowed until something is done to make the tape position match the
user's expectation (e.g., rewind the tape). Add MTIOCGET and MTLOAD to
operations allowed after reset. MTIOCGET is modified to not touch the tape
if pos_unknown is non-zero. The tape location is known after MTLOAD.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219419#c14
Link: https://lore.kernel.org/r/20241106095723.63254-3-Kai.Makisara@kolumbus.fi
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index b91da7b51814a..b3caa3b9722d1 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3504,6 +3504,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	int i, cmd_nr, cmd_type, bt;
 	int retval = 0;
 	unsigned int blk;
+	bool cmd_mtiocget;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3617,6 +3618,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			 */
 			if (mtc.mt_op != MTREW &&
 			    mtc.mt_op != MTOFFL &&
+			    mtc.mt_op != MTLOAD &&
 			    mtc.mt_op != MTRETEN &&
 			    mtc.mt_op != MTERASE &&
 			    mtc.mt_op != MTSEEK &&
@@ -3730,17 +3732,28 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		goto out;
 	}
 
+	cmd_mtiocget = cmd_type == _IOC_TYPE(MTIOCGET) && cmd_nr == _IOC_NR(MTIOCGET);
+
 	if ((i = flush_buffer(STp, 0)) < 0) {
-		retval = i;
-		goto out;
-	}
-	if (STp->can_partitions &&
-	    (i = switch_partition(STp)) < 0) {
-		retval = i;
-		goto out;
+		if (cmd_mtiocget && STp->pos_unknown) {
+			/* flush fails -> modify status accordingly */
+			reset_state(STp);
+			STp->pos_unknown = 1;
+		} else { /* return error */
+			retval = i;
+			goto out;
+		}
+	} else { /* flush_buffer succeeds */
+		if (STp->can_partitions) {
+			i = switch_partition(STp);
+			if (i < 0) {
+				retval = i;
+				goto out;
+			}
+		}
 	}
 
-	if (cmd_type == _IOC_TYPE(MTIOCGET) && cmd_nr == _IOC_NR(MTIOCGET)) {
+	if (cmd_mtiocget) {
 		struct mtget mt_status;
 
 		if (_IOC_SIZE(cmd_in) != sizeof(struct mtget)) {
-- 
2.43.0



