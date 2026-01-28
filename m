Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B27A1E9B1A;
	Wed, 28 Jan 2026 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614300; cv=none; b=UY225p8RYOe5rz39Ji21peNPibJes4u/byPaNTmY0okHCgHzGLUYEXzP2Hp5i5cVoTwh9OqsbR/KgZf2XXeXvoWutIV0vswJc2oSDAJIyrxUhkzqEdf+1OIBZsvIrneYoP4nvuUZue3hGOD2Tnj1XRErHVTODHN1mtGTmNPoMfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614300; c=relaxed/simple;
	bh=SDdG2h+/5V1hhoxgFB7bNd9VzTXBj/BbMuxm6FD3fCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYFJTTMMHS70t5QZu/As4vbmJvP9ohtwIzYaCthgcVblHRTY6Gn8sUEvI7PhpYxLWpxn7W/HfluZKnjdBB1L7Ho95wmjhb6YLRm8cHDOscp+SaWrXYUjCswiR/qYHD+LmxoKreZSHaDLVCsEOkZqlzDVl39NuidtueuwBEucYsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gI1JI5EE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gI1JI5EE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14DDC4CEF7;
	Wed, 28 Jan 2026 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614300;
	bh=SDdG2h+/5V1hhoxgFB7bNd9VzTXBj/BbMuxm6FD3fCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gI1JI5EEj/o2y//Vl4o8HPtYBM+zYn6frMPQ+wzyRJVpCaDppumnICrOWq1vwb0QL
	 /CY9SfuWkW5PLl/lGuNc1oDhzdZu/d/1AxJ4b9BkPzdO6xmqbHvJCs/qDp9Jf8xvlT
	 GPn/au87nirsxwPZbB++tdQwUx923BlTfIuZbrzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Wojtek Wasko <wwasko@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/254] ptp: Add PHC file mode checks. Allow RO adjtime() without FMODE_WRITE.
Date: Wed, 28 Jan 2026 16:21:10 +0100
Message-ID: <20260128145348.210690269@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wojtek Wasko <wwasko@nvidia.com>

[ Upstream commit b4e53b15c04e3852949003752f48f7a14ae39e86 ]

Many devices implement highly accurate clocks, which the kernel manages
as PTP Hardware Clocks (PHCs). Userspace applications rely on these
clocks to timestamp events, trace workload execution, correlate
timescales across devices, and keep various clocks in sync.

The kernel’s current implementation of PTP clocks does not enforce file
permissions checks for most device operations except for POSIX clock
operations, where file mode is verified in the POSIX layer before
forwarding the call to the PTP subsystem. Consequently, it is common
practice to not give unprivileged userspace applications any access to
PTP clocks whatsoever by giving the PTP chardevs 600 permissions. An
example of users running into this limitation is documented in [1].
Additionally, POSIX layer requires WRITE permission even for readonly
adjtime() calls which are used in PTP layer to return current frequency
offset applied to the PHC.

Add permission checks for functions that modify the state of a PTP
device. Continue enforcing permission checks for POSIX clock operations
(settime, adjtime) in the POSIX layer. Only require WRITE access for
dynamic clocks adjtime() if any flags are set in the modes field.

[1] https://lists.nwtime.org/sympa/arc/linuxptp-users/2024-01/msg00036.html

Changes in v4:
- Require FMODE_WRITE in ajtime() only for calls modifying the clock in
  any way.

Acked-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Wojtek Wasko <wwasko@nvidia.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_chardev.c | 16 ++++++++++++++++
 kernel/time/posix-clock.c |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 6eecb53b3e670..1ed12e86ee000 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -153,6 +153,10 @@ long ptp_ioctl(struct posix_clock_context *pccontext, unsigned int cmd,
 
 	case PTP_EXTTS_REQUEST:
 	case PTP_EXTTS_REQUEST2:
+		if ((pccontext->fp->f_mode & FMODE_WRITE) == 0) {
+			err = -EACCES;
+			break;
+		}
 		memset(&req, 0, sizeof(req));
 
 		if (copy_from_user(&req.extts, (void __user *)arg,
@@ -194,6 +198,10 @@ long ptp_ioctl(struct posix_clock_context *pccontext, unsigned int cmd,
 
 	case PTP_PEROUT_REQUEST:
 	case PTP_PEROUT_REQUEST2:
+		if ((pccontext->fp->f_mode & FMODE_WRITE) == 0) {
+			err = -EACCES;
+			break;
+		}
 		memset(&req, 0, sizeof(req));
 
 		if (copy_from_user(&req.perout, (void __user *)arg,
@@ -262,6 +270,10 @@ long ptp_ioctl(struct posix_clock_context *pccontext, unsigned int cmd,
 
 	case PTP_ENABLE_PPS:
 	case PTP_ENABLE_PPS2:
+		if ((pccontext->fp->f_mode & FMODE_WRITE) == 0) {
+			err = -EACCES;
+			break;
+		}
 		memset(&req, 0, sizeof(req));
 
 		if (!capable(CAP_SYS_TIME))
@@ -400,6 +412,10 @@ long ptp_ioctl(struct posix_clock_context *pccontext, unsigned int cmd,
 
 	case PTP_PIN_SETFUNC:
 	case PTP_PIN_SETFUNC2:
+		if ((pccontext->fp->f_mode & FMODE_WRITE) == 0) {
+			err = -EACCES;
+			break;
+		}
 		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
 			err = -EFAULT;
 			break;
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index b130bb56cc4e0..827abede72745 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -253,7 +253,7 @@ static int pc_clock_adjtime(clockid_t id, struct __kernel_timex *tx)
 	if (err)
 		return err;
 
-	if ((cd.fp->f_mode & FMODE_WRITE) == 0) {
+	if (tx->modes && (cd.fp->f_mode & FMODE_WRITE) == 0) {
 		err = -EACCES;
 		goto out;
 	}
-- 
2.51.0



