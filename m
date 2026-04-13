Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A212F8BC3;
	Mon, 13 Apr 2026 16:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097283; cv=none; b=M0TC2EHcD6SX2T3CXH34HATXllMgUOm7VJmL3/3HgGsai0JGrgCo7oBeE8JphkXjwswiy02xNiN7YJHBJmWGFYilske6zFMP7LLgKrNzVoAG7OnMpMCbBkFPpjU/hcCBskzx/u8UpXDnFZ5wEhzo2kE20c0tiEw6nT9/Xfrwa4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097283; c=relaxed/simple;
	bh=4GkV4vlRyb+8CuISK8I51igailxOzHtBLlDTR0IKVkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nV/xnZU7P+zKkXJQloxAGMR5cxleAVG1PEu6me1PoVRKVGfIbpT2ska+Q8gcbnFbl3HR+ftOjb+DgrpojgjX/qSbz5lfmjjdwYVzZoMF7NOPJpboiFJGnJSsFHG/M/SLh1cf1S1Uwv1elB+Rn29HbzUbARuSspfTMfatgTOaNSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GKl9+Ax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GKl9+Ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B6CC2BCAF;
	Mon, 13 Apr 2026 16:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097283;
	bh=4GkV4vlRyb+8CuISK8I51igailxOzHtBLlDTR0IKVkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GKl9+AxqOZ/bo7mOtUi9bK1PFBYzKtSX1XDSuDANr0Wmm4D3P1D9G9b9GGugyQTF
	 zjf321PMTDk4hNKVnh2w+ge0qG/9W3KY3cVz9M3p12wxZ/SCxjMdWk8c3O8QbuqHS9
	 tAS2JuZHH/jhjBsgN0Noe085HEvvascbLmKZsijk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/570] indirect_call_wrapper: do not reevaluate function pointer
Date: Mon, 13 Apr 2026 17:53:27 +0200
Message-ID: <20260413155833.288241724@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 710f5c76580306cdb9ec51fac8fcf6a8faff7821 ]

We have an increasing number of READ_ONCE(xxx->function)
combined with INDIRECT_CALL_[1234]() helpers.

Unfortunately this forces INDIRECT_CALL_[1234]() to read
xxx->function many times, which is not what we wanted.

Fix these macros so that xxx->function value is not reloaded.

$ scripts/bloat-o-meter -t vmlinux.0 vmlinux
add/remove: 0/0 grow/shrink: 1/65 up/down: 122/-1084 (-962)
Function                                     old     new   delta
ip_push_pending_frames                        59     181    +122
ip6_finish_output                            687     681      -6
__udp_enqueue_schedule_skb                  1078    1072      -6
ioam6_output                                2319    2312      -7
xfrm4_rcv_encap_finish2                       64      56      -8
xfrm4_output                                 297     289      -8
vrf_ip_local_out                             278     270      -8
vrf_ip6_local_out                            278     270      -8
seg6_input_finish                             64      56      -8
rpl_output                                   700     692      -8
ipmr_forward_finish                          124     116      -8
ip_forward_finish                            143     135      -8
ip6mr_forward2_finish                        100      92      -8
ip6_forward_finish                            73      65      -8
input_action_end_bpf                        1091    1083      -8
dst_input                                     52      44      -8
__xfrm6_output                               801     793      -8
__xfrm4_output                                83      75      -8
bpf_input                                    500     491      -9
__tcp_check_space                            530     521      -9
input_action_end_dt6                         291     280     -11
vti6_tnl_xmit                               1634    1622     -12
bpf_xmit                                    1203    1191     -12
rpl_input                                    497     483     -14
rawv6_send_hdrinc                           1355    1341     -14
ndisc_send_skb                              1030    1016     -14
ipv6_srh_rcv                                1377    1363     -14
ip_send_unicast_reply                       1253    1239     -14
ip_rcv_finish                                226     212     -14
ip6_rcv_finish                               300     286     -14
input_action_end_x_core                      205     191     -14
input_action_end_x                           355     341     -14
input_action_end_t                           205     191     -14
input_action_end_dx6_finish                  127     113     -14
input_action_end_dx4_finish                  373     359     -14
input_action_end_dt4                         426     412     -14
input_action_end_core                        186     172     -14
input_action_end_b6_encap                    292     278     -14
input_action_end_b6                          198     184     -14
igmp6_send                                  1332    1318     -14
ip_sublist_rcv                               864     848     -16
ip6_sublist_rcv                             1091    1075     -16
ipv6_rpl_srh_rcv                            1937    1920     -17
xfrm_policy_queue_process                   1246    1228     -18
seg6_output_core                             903     885     -18
mld_sendpack                                 856     836     -20
NF_HOOK                                      756     736     -20
vti_tunnel_xmit                             1447    1426     -21
input_action_end_dx6                         664     642     -22
input_action_end                            1502    1480     -22
sock_sendmsg_nosec                           134     111     -23
ip6mr_forward2                               388     364     -24
sock_recvmsg_nosec                           134     109     -25
seg6_input_core                              836     810     -26
ip_send_skb                                  172     146     -26
ip_local_out                                 140     114     -26
ip6_local_out                                140     114     -26
__sock_sendmsg                               162     136     -26
__ip_queue_xmit                             1196    1170     -26
__ip_finish_output                           405     379     -26
ipmr_queue_fwd_xmit                          373     346     -27
sock_recvmsg                                 173     145     -28
ip6_xmit                                    1635    1607     -28
xfrm_output_resume                          1418    1389     -29
ip_build_and_send_pkt                        625     591     -34
dst_output                                   504     432     -72
Total: Before=25217686, After=25216724, chg -0.00%

Fixes: 283c16a2dfd3 ("indirect call wrappers: helpers to speed-up indirect calls of builtin")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260227172603.1700433-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/indirect_call_wrapper.h | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
index c1c76a70a6ce9..227cee5e2a98b 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -16,22 +16,26 @@
  */
 #define INDIRECT_CALL_1(f, f1, ...)					\
 	({								\
-		likely(f == f1) ? f1(__VA_ARGS__) : f(__VA_ARGS__);	\
+		typeof(f) __f1 = (f);					\
+		likely(__f1 == f1) ? f1(__VA_ARGS__) : __f1(__VA_ARGS__);	\
 	})
 #define INDIRECT_CALL_2(f, f2, f1, ...)					\
 	({								\
-		likely(f == f2) ? f2(__VA_ARGS__) :			\
-				  INDIRECT_CALL_1(f, f1, __VA_ARGS__);	\
+		typeof(f) __f2 = (f);					\
+		likely(__f2 == f2) ? f2(__VA_ARGS__) :			\
+				  INDIRECT_CALL_1(__f2, f1, __VA_ARGS__);	\
 	})
 #define INDIRECT_CALL_3(f, f3, f2, f1, ...)					\
 	({									\
-		likely(f == f3) ? f3(__VA_ARGS__) :				\
-				  INDIRECT_CALL_2(f, f2, f1, __VA_ARGS__);	\
+		typeof(f) __f3 = (f);						\
+		likely(__f3 == f3) ? f3(__VA_ARGS__) :				\
+				  INDIRECT_CALL_2(__f3, f2, f1, __VA_ARGS__);	\
 	})
 #define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...)					\
 	({									\
-		likely(f == f4) ? f4(__VA_ARGS__) :				\
-				  INDIRECT_CALL_3(f, f3, f2, f1, __VA_ARGS__);	\
+		typeof(f) __f4 = (f);						\
+		likely(__f4 == f4) ? f4(__VA_ARGS__) :				\
+				  INDIRECT_CALL_3(__f4, f3, f2, f1, __VA_ARGS__);	\
 	})
 
 #define INDIRECT_CALLABLE_DECLARE(f)	f
-- 
2.51.0



