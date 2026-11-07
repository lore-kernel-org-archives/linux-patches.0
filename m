Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062607;
	b=sC6HDPK/kYQfUsZsQPuC073AWZ/puzlRnwDf08fd/hxU3hIPQvSQsKySaApmkiX4Uwz9
	 1mTWp6U/WN9yGhrAjkjU8fmK0RHEsoUDPPMvUAY6/Ps28cCM1cwA2QtZSl3eFEKIACzgY
	 0tybJ1B22p2OXbQEjkI4q7z+7xw4z7CsC4ma0nBgpgI7LEhl/gj60sFXorAFXrvCcmaDt
	 Twez0e8sReOIfA/CW5aCVlq920iqmWyVJ2Xxys0Uev7Fza9qL/rJPZ68MbGm0/vJjSChG
	 VOQr1j3k6Yr7zhPK8nOXRALs2OLkxRNhKgqYoDGFmh6mfPNRM3P4f37fvH3kfdH8NZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vk51C6TzxSMMSwTXKpnDt9RFHlG1txOAAn7EYwFPhBo=;
	b=iyhHfW9AvIXaARTOx+vr/GXTcK3PnezlILvZWI4DZBYHA3AgpKocEnS4jZZHwwu52QiQ
	 lmXoKM1q2yJ3sQEt12fs1M+dR4RzFtgp74Zlsb+GfvJye6GvYxAF+BRny+thMI8GKQDM5
	 AV3GHHSc8vluQdJc3KANT/5INTU64zud8X+rv/PYyDVVPPqgGTXQxuQp7Wn1+ArEc79bc
	 +pOXvmxtdjKDlzcCPVmTHGATl7Jz7yHtQ8MPh/MFhhSV32+aQay1pPUS5XEOy9G3EzRQc
	 KQ+tY8RoNLP/kZLk00dmvJp+nWsJ02HWxsER/HrYBvk3iLOvW59DNxhhMrbabVd/CGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fpb2Wja6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E440606A334;
	Sat,  7 Nov 2026 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fpb2Wja6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333191F008A1;
	Sat,  7 Nov 2026 14:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062607;
	bh=vk51C6TzxSMMSwTXKpnDt9RFHlG1txOAAn7EYwFPhBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fpb2Wja6oKCiuqCft0yDEuKaT6/Q1d3F52TV76Vu3nmY1GVSwOSAn2t66ZXsLEjJQ
	 emeGmngW0aMJNcbLzcp1MTj0AQ5SeyrrdhKwf3mIRRkHLR+3dEpvQhrGj8qd5rwb6+
	 zdDLZCKawbXDSNRRIKHpgKMrX3xrAAO3S5SNSyoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1480/1536] tcp: limit tcp_tso_rtt_log to a valid shift count
Date: Sat,  7 Nov 2026 08:58:16 -0500
Message-ID: <20261107135039.418374880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingjie Wang <1075151112@qq.com>

[ Upstream commit 850a7225bc61cdfaf0c4b02ff341ae7cb54902f5 ]

tcp_tso_autosize() right-shifts the u32 returned by tcp_min_rtt() by
sysctl_tcp_tso_rtt_log. The sysctl uses proc_dou8vec_minmax() without
an upper bound, so it accepts values through 255. Values above 31 make
the shift undefined.

A process with CAP_NET_ADMIN in the target network namespace can set the
per-netns sysctl. With CONFIG_UBSAN_SHIFT=y, setting it to 32 and sending
TCP data over loopback triggers:

  UBSAN: shift-out-of-bounds in net/ipv4/tcp_output.c:2264:30
  shift exponent 32 is too large for 32-bit type 'unsigned int'
  Call Trace:
   __ubsan_handle_shift_out_of_bounds
   tcp_tso_segs
   tcp_write_xmit
   __tcp_push_pending_frames
   tcp_push
   tcp_sendmsg_locked

Limit the sysctl to 31, the largest valid shift count for a u32, and
document the accepted range. Writes of larger values now fail with
-EINVAL.

On a UBSAN/KASAN build of the net tree, values 0 and 31 remained
accepted, values 32 and 255 returned -EINVAL, and TCP traffic with the
valid boundary values produced no sanitizer diagnostics.

Fixes: 65466904b015 ("tcp: adjust TSO packet sizes based on min_rtt")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/tencent_31D2FFCCE76C50A695A1270151F825E90906@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 2 ++
 net/ipv4/sysctl_net_ipv4.c             | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 9e3da2008c412..bc41d23a3376a 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -952,6 +952,8 @@ tcp_tso_rtt_log - INTEGER
 
 	If you want to use the old autosizing, set this sysctl to 0.
 
+	Possible values are [0, 31], inclusive.
+
 	Default: 9  (2^9 = 512 usec)
 
 tcp_pacing_ss_ratio - INTEGER
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 00d3be968a53d..b0904a606f3b3 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -26,6 +26,7 @@ static int ip_local_port_range_max[] = { 65535, 65535 };
 static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
 static int tcp_app_win_max = 31;
+static int tcp_tso_rtt_log_max = 31;
 static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
 static int tcp_min_snd_mss_max = 65535;
 static int ip_privileged_port_min;
@@ -1349,6 +1350,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra2		= &tcp_tso_rtt_log_max,
 	},
 	{
 		.procname	= "tcp_min_rtt_wlen",
-- 
2.53.0



