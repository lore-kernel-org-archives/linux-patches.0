Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037964;
	b=EfMQ1NQ09j56lJOhRUJfTEb6UqtAzMiCFK+zUYxQx2abWBTIyu1lgHDjer+Tu1l9XUpK
	 Fp37PVprmFBqVTgMyRPQCnZM4RCo19fD4ELGNYdiE/l0u3BVGIl6YGKt1oF18Nh9uBAfY
	 PsOU5QkX+mKP2+2e/+Xgk3W9F68i00HKn/hzasVXDaXyUo6PJJkWj3MUkELCjRzYoSd7c
	 ok7CWoYOwDPNsSLoJBrqXgjWd+XdsHiraliGL6stOTejUsN+TBQV4Bf2JwB0oLce/GGde
	 LssutnPUt48mVfSS6e9lrY4hHydq0k4M7EekuntFwF3WWFkKpbZkSi4jtJhwDhOfM6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e2F9yKBbwY/5ua+ulxNy70Ht6KS35rDcdJymhrhh6HM=;
	b=cL3JJST8hsBsfHBAqhDb2kaTDUZR9qO57JE+k/ALt94+bo/3m0OOU4eWMiX7qmI4cpai
	 fr+ihMJapKKqdReKhk5iLSGKaujv5BJ+0+XupgzpdBVT6ynQzir/3+OA35w8RDD1cEmCn
	 HqOaBvdFw/ANec1VrtTunB+BQ19a8bZCiuiYrQunrEKdQS8AJIzH34BRotUFX/AjFPzBU
	 DVyOvrt9e8I7/fe6C87hU8zjbWLDjPNqpjrNDs9KBLt3ghGERThQufDo1O1o/tKwXybRt
	 xISDs547I0jo65NUN5sbIWEVkYnJ6caoKIn9L3r17IjGUGRbA3xlB/P5s4bCPvPK1uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JF/ZsN6F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BA3606A31C;
	Wed, 18 Nov 2026 21:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JF/ZsN6F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EC51F000C4;
	Wed, 18 Nov 2026 21:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037964;
	bh=e2F9yKBbwY/5ua+ulxNy70Ht6KS35rDcdJymhrhh6HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JF/ZsN6F/fwo4Rig7B9F2sqr4Id4MZ4Xi5VM2YzhATnYA+rj6q4sfzrtT/QLEoCRc
	 0wFapL5ipZjxzl+/3LtrzM7R8i7mprfGFYKDZEPuQZ/dnfUd18RB99+FTkPGT0o6hR
	 aUQ4vczJ1zwUV7RxmObsOQ6SxiLOfXpMjQBreKRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Caron <valentin.caron@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1579/3318] perf cs-etm: fix a compilation issue in cs_etm_decoder__set_tid()
Date: Wed, 18 Nov 2026 15:36:41 +0100
Message-ID: <20261118150408.487539816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Caron <valentin.caron@foss.st.com>

When compiling coresight tool with the command:
make -C tools/perf CORESIGHT=1 all

The following build issue occurs:
util/cs-etm-decoder/cs-etm-decoder.c:551:15: error: too many arguments to
function 'cs_etm_decoder__buffer_packet'
  551 |         ret = cs_etm_decoder__buffer_packet(etmq, packet_queue,
      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by removing the parameter "etmq" from function call to match its
declaration:
cs_etm_decoder__buffer_packet(struct cs_etm_packet_queue *packet_queue,
			      const u8 trace_chan_id,
			      enum cs_etm_sample_type sample_type)

Fixes: 99d324594165 ("perf cs-etm: Queue context packets for frontend")
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm-decoder/cs-etm-decoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
index 277da9f767b9d..caacab8c92e26 100644
--- a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
+++ b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
@@ -548,7 +548,7 @@ cs_etm_decoder__set_tid(struct cs_etm_queue *etmq,
 				elem->context.exception_level, tid))
 		return OCSD_RESP_FATAL_SYS_ERR;
 
-	ret = cs_etm_decoder__buffer_packet(etmq, packet_queue, trace_chan_id,
+	ret = cs_etm_decoder__buffer_packet(packet_queue, trace_chan_id,
 					    CS_ETM_CONTEXT);
 	if (ret != OCSD_RESP_CONT && ret != OCSD_RESP_WAIT)
 		return ret;
-- 
2.53.0



