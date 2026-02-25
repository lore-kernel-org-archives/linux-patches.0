Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33D54369A;
	Wed, 25 Feb 2026 01:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982959; cv=none; b=IDGFYIIbbUHhTC4XX0LbMBJLCxw9h5k9avUKzOKsI3iWiATJxCYb2ggCgSKuFRq/6WbW2EU+C5BOffrA3HErm6vyEc4be1lzdVzILTcl9RtDyo9iPEM+Qq1sdYFTj7lCaMtboux2NOxL6DLpo+zQKpd38K6jR6GpB+A2BPckqmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982959; c=relaxed/simple;
	bh=StJYLfUb9eb59OCXpzrUAHlvD2EfCjgiyBV+u68gOhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=By38X/z6bfiAIGc887fmo2D0Jjvv/+zu84ty+AwT+kdeGOGd5Q6fy1crKbOlweSODVf7jMpc4tsa1AkdfqMm9Ddr+bqouwbYKF+7Lg/H9dnaO3Iqdq9upH3x2YFri4YGUKqziqy1OrK+vIOTkml5xfrV1AtxWwgYbHD0C/lwYTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSsxXzbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSsxXzbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A67C19423;
	Wed, 25 Feb 2026 01:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982959;
	bh=StJYLfUb9eb59OCXpzrUAHlvD2EfCjgiyBV+u68gOhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSsxXzbosXTgkE9/duD2lksUH/7Y3QO2D2GA7Xoer4wGuUyokMVn5eiY8vUocCIPO
	 XsvksSRGfjythyM3kAXQeq3Rns0SYLC1JJcLV6NSxSuWBY/ynkYP+dqKDe+b+xr4dm
	 nUJ7I3F6m+4PgRYvrM8QaKplVdO8Py56f+RH6kjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 136/781] selftests/xsk: properly handle batch ending in the middle of a packet
Date: Tue, 24 Feb 2026 17:14:05 -0800
Message-ID: <20260225012403.006117301@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/bpf/prog_tests/test_xsk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_xsk.c b/tools/testing/selftests/bpf/prog_tests/test_xsk.c
index 5af28f359cfda..69a5a9a5189b0 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_xsk.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_xsk.c
@@ -1090,6 +1090,8 @@ static int __receive_pkts(struct test_spec *test, struct xsk_socket_info *xsk)
 			xsk_ring_prod__cancel(&umem->fq, nb_frags);
 		}
 		frags_processed -= nb_frags;
+		pkt_stream_cancel(pkt_stream);
+		pkts_sent--;
 	}
 
 	if (ifobj->use_fill_ring)
-- 
2.51.0



