Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623134;
	b=cCbVUU33kMcOG3uOIdvAhXQR9KFiWks4Pc6jh0EuV+RL41tu70fy7jDIw5VLgXoZHMuw
	 ztivlAJl5bm5YFIXEou0jlMiaLjhdhd8a0DLxtLrDhkiR3bw01s5eNPh11Hpfk2QuVA2F
	 aIt/OlxadI2vIxBmy6HFfXyFvDyMfi3u/p1AeJXBOKvDdvyBtfJW/fCUYqLXi5JAwRWmV
	 obxwzGr/GM1yd1+z/g0L1M2+ZV17+Cr7fs9aoM8/VdmgWfAujeeI0hkdnw6Tt5DRmQyhw
	 nDNAJ+tp657tlRbJDi4EQY2Mzync/zDvRtcMtaHv79UOYmGh0UefYN/4DLrsxQTSl/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kI80WjpKlBlr01iJaAPItDC2fNKzUjSR0fujPAcG2G0=;
	b=jCT7dmm4+cUDjclcNdIUuY9ZTgBEQ8fZnRP6sYTcUILYr5fKqR7MkY63QZoLUqPhMkW0
	 kLTZ1cyPIluzUvMJOWIGDjFsl6wMpXxqwS6iV2pSBFHgGC7Z+MFZ5dF5QS7AELYoiLh9A
	 VVPKR/372pNfwP9SLxfvUhQTxouES7AMFhYmVZrmdE260pvlZlj33pQ6d/hEKLf2Uwwk7
	 KcLtfy6txdoygGrdaWDNXEQJeBV/AnytAfQ8GDOR6WbYrYQGW2p0QsFt2rbBXMBBkpNJh
	 uoumFQ4nGNQrA7ICG3H6a6Jl2UlWfQen8HEbvvY5nzFEoGxCtKQB6MXSyIbo0KyLrSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kM/GkVSP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F8C606A321;
	Wed, 25 Nov 2026 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kM/GkVSP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936311F000C0;
	Wed, 25 Nov 2026 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623134;
	bh=kI80WjpKlBlr01iJaAPItDC2fNKzUjSR0fujPAcG2G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kM/GkVSPH8ScFhEJPihpzVfTe4CbAE5FlG4rrY5L13b3HOsMDtEdhstOPg0NQYNP2
	 Ob+MxBy1SoLOqVNFVi7eolbqNf0DF5voMuAdtRP4OwIgLO8pUSQ2i6nyIovcl/zpXC
	 hu3pEqd1zmbz8cqLeI9opgfJJGLJrm8oRmOSmDJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 762/990] timekeeping: Refresh auxiliary base before offset validation
Date: Wed, 25 Nov 2026 15:35:29 +0100
Message-ID: <20261125143839.905928456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

commit c1b96ba87e3caaa701d6dba254e58db7cc3c99be upstream.

timekeeping_forward_now() can advance an auxiliary timekeeper across a
second boundary without refreshing tkr_mono.base. The negative-time
check in __timekeeping_inject_offset() then uses the stale base and
rejects valid ADJ_SETOFFSET adjustments with -EINVAL.

Refresh the derived timekeeper data before calculating the current
auxiliary time, as aux_clock_set() already does.

On 7.4-rc1, a valid negative adjustment fails at the first second
rollover. The patched kernel accepts all 12 tested rollover adjustments
and continues to reject invalid negative offsets.

Fixes: 2c8aea59c206 ("timekeeping: Add auxiliary clock support to __timekeeping_inject_offset()")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261103090605.1292660-1-thnkslprpt@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1503,6 +1503,7 @@ static int __timekeeping_inject_offset(s
 		struct tk_read_base *tkr_mono = &tks->tkr_mono;
 		ktime_t now, offs;
 
+		tk_update_ktime_data(tks);
 		/* Get the current time */
 		now = ktime_add_ns(tkr_mono->base, timekeeping_get_ns(tkr_mono));
 		/* Add the relative offset change */


