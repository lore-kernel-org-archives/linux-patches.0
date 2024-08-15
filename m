Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A481A00F7;
	Thu, 15 Aug 2024 13:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729059; cv=none; b=g+yEqeKWlPDHVAzLjj/Vlp5jakpsDvbu/jtwTsZ2VENCM/ujMALauCKvTlJD50vyLroAicyF+7z/ZwiIK/EXh31aN9G+AuN2/QbNJ0COid+sYVWOi+1awh7Nia/K8OV7Vw6D+R+2luqn0V2MBORJDKbuJ4SbaWYgw+r+wanPrts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729059; c=relaxed/simple;
	bh=cPAOUTjiaXWKI/K7y5ta0JjRKkSRJGXAoyC1mfwpq+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkH1+D+4hoo5jKiKgSsG77Z3/mAAOhwmuutKJsRtavNOtfalcPQc7h5R3IfzqaGwMdmytQ9SCDyyGHXGvKpL1Yf1VaWMi620Gs8B+zOn9R9dF4sC6La24iVhkzl8ETSDDqBGVy2pHiyfl2sHt0ELSuaZOwoB1c7BpMG47HjQ8VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6U6RQKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6U6RQKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C17C32786;
	Thu, 15 Aug 2024 13:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729059;
	bh=cPAOUTjiaXWKI/K7y5ta0JjRKkSRJGXAoyC1mfwpq+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6U6RQKBBtoJ8r+VgqEL1JmxXE8kT80l+lH40e4lkb1qjwt/eIogz2aAMktrk2+Ln
	 PIh/O43jFPfXmYEKvl3kBsSGIHNHDcjb1YRw4e2ptx+UFdK9l1u18ptWnDvRrhV7RF
	 xmtMy6ugxt+d+h51nqr0MnuDBXBhtUh+FJTpTsc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Miroslav Lichvar <mlichvar@redhat.com>
Subject: [PATCH 4.19 180/196] ntp: Safeguard against time_constant overflow
Date: Thu, 15 Aug 2024 15:24:57 +0200
Message-ID: <20240815131858.959616435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Stitt <justinstitt@google.com>

commit 06c03c8edce333b9ad9c6b207d93d3a5ae7c10c0 upstream.

Using syzkaller with the recently reintroduced signed integer overflow
sanitizer produces this UBSAN report:

UBSAN: signed-integer-overflow in ../kernel/time/ntp.c:738:18
9223372036854775806 + 4 cannot be represented in type 'long'
Call Trace:
 handle_overflow+0x171/0x1b0
 __do_adjtimex+0x1236/0x1440
 do_adjtimex+0x2be/0x740

The user supplied time_constant value is incremented by four and then
clamped to the operating range.

Before commit eea83d896e31 ("ntp: NTP4 user space bits update") the user
supplied value was sanity checked to be in the operating range. That change
removed the sanity check and relied on clamping after incrementing which
does not work correctly when the user supplied value is in the overflow
zone of the '+ 4' operation.

The operation requires CAP_SYS_TIME and the side effect of the overflow is
NTP getting out of sync.

Similar to the fixups for time_maxerror and time_esterror, clamp the user
space supplied value to the operating range.

[ tglx: Switch to clamping ]

Fixes: eea83d896e31 ("ntp: NTP4 user space bits update")
Signed-off-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240517-b4-sio-ntp-c-v2-1-f3a80096f36f@google.com
Closes: https://github.com/KSPP/linux/issues/352
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/ntp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -692,11 +692,10 @@ static inline void process_adjtimex_mode
 		time_esterror = clamp(txc->esterror, (__kernel_long_t)0, (__kernel_long_t)NTP_PHASE_LIMIT);
 
 	if (txc->modes & ADJ_TIMECONST) {
-		time_constant = txc->constant;
+		time_constant = clamp(txc->constant, (__kernel_long_t)0, (__kernel_long_t)MAXTC);
 		if (!(time_status & STA_NANO))
 			time_constant += 4;
-		time_constant = min(time_constant, (long)MAXTC);
-		time_constant = max(time_constant, 0l);
+		time_constant = clamp(time_constant, (long)0, (long)MAXTC);
 	}
 
 	if (txc->modes & ADJ_TAI &&


