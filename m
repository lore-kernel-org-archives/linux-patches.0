Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29240288C08;
	Wed, 25 Feb 2026 01:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983847; cv=none; b=lEwfL1yQ5KoVDwUM+PRAtCmpOigHROEo5h8dxU6yiRKPImCWBMhPwVnYKUlnUx+xOpTF4VUu9VImiy4ZGmZnth4d/h0SOg8VfI0uXylg5MDzFdrM5ZDe07yOROT2kooHMI3dayYA+O+VnVD9LVSDMeak97vxwD2XhlHq+zkKOZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983847; c=relaxed/simple;
	bh=fbTLmntlULNqEOFf8ABl0B6rQQ/lwRQyd+sZL/T8N24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ox3zGEc0OWe/0+4LzIy0Kic3/GNrfZfclO4FJSwIfOUNjxGI6wRo/J1ie83qICQ0g79vgrfm/t1kk3SuExth6CmTuKS505k/L4qrpO0PfVHnw8Fh8k/PMfHVlWadxPRfyTEAqwQW/XjXNFnKQMovaK+EL+IfcR3P+McRY/CzZZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP5Dycx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP5Dycx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6606C116D0;
	Wed, 25 Feb 2026 01:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983847;
	bh=fbTLmntlULNqEOFf8ABl0B6rQQ/lwRQyd+sZL/T8N24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VP5Dycx/Q5Ul773HyuaZgMzEpsDy9PkoEdsXt/MJA9Pj4t22xgqKsys6F33Qpz9Bq
	 1B7pAn8M/MtR+EPnLi8zAiSBVLPUQfJl/kLJbn3l1ARGV2LOV8288LfdsrPaoF952Y
	 zeP8oAkP+mHkRFXLaCPNrQplJCrkZ0O0w5Yyrsdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/641] selftests/xsk: properly handle batch ending in the middle of a packet
Date: Tue, 24 Feb 2026 17:17:30 -0800
Message-ID: <20260225012352.151667329@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 42e41b2a0afa04ca49ee2725aadf90ccb058ed28 ]

Referenced commit reduced the scope of the variable pkt, so now it has to
be reinitialized via pkt_stream_get_next_rx_pkt(), which also increments
some counters. When the packet is interrupted by the batch ending, pkt
stream therefore proceeds to the next packet, while xsk ring still contains
the previous one, this results in a pkt_nb mismatch.

Decrement the affected counters when packet is interrupted.

Fixes: 8913e653e9b8 ("selftests/xsk: Iterate over all the sockets in the receive pkts function")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://lore.kernel.org/r/20260203155103.2305816-2-larysa.zaremba@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xsk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_xsk.c b/tools/testing/selftests/bpf/test_xsk.c
index 02250f29f9946..b52f597ea9bd2 100644
--- a/tools/testing/selftests/bpf/test_xsk.c
+++ b/tools/testing/selftests/bpf/test_xsk.c
@@ -1027,6 +1027,8 @@ static int __receive_pkts(struct test_spec *test, struct xsk_socket_info *xsk)
 			xsk_ring_prod__cancel(&umem->fq, nb_frags);
 		}
 		frags_processed -= nb_frags;
+		pkt_stream_cancel(pkt_stream);
+		pkts_sent--;
 	}
 
 	if (ifobj->use_fill_ring)
-- 
2.51.0



