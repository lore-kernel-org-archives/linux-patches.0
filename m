Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D33EEC8;
	Tue,  8 Oct 2024 12:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390326; cv=none; b=GO5VsiIvHsM1wfgV1cfh3ua6Ww7OV57/2vCDCBLZagMz7ST6aPL3CIzwrnWc40AI/1CgbfHXqOV/6Op5ZuvL1ncVcNgxUJncrre/nZcITzW9r56R9er3QS6aAohDc9olwwU/dC+qfeThSsDtLILjEgh5eZaqOsEoBVpN4Kfexes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390326; c=relaxed/simple;
	bh=VOSFAR7pua+cl9ZLgVXrHVM4v5+t35H9/LBD0ulmWTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl5tIo9E/V+ydKw5bwphHHXoGcg4F74v8IogEcszYoUOAU+EdYRAFPxo5ZuWiJBvn9P4WaTyRcSDU5iBEvSK323Nu5MFQI1m/io90hPgi/bOcZ7ldQ06MUC96cf4vABmxOVTIjNkn8tZYKi8NgMZCrC6OmR0XguO4/ZeGQH10zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6VmkL9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6VmkL9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14192C4CECD;
	Tue,  8 Oct 2024 12:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390326;
	bh=VOSFAR7pua+cl9ZLgVXrHVM4v5+t35H9/LBD0ulmWTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6VmkL9tLZIeBQH3HBCGUBNfvs+9V52TWX3BqFGGTya2FBIxWvS9rF1o0YbRp0Jts
	 WmJahNBvL6LG3BEr/3yuY/UBT5MtAqNSE4I7o0icmbLVhzvBraUKICG2nz36pJj6dm
	 mlSFOT2HcDXJmvN7vkjtox9FXmD9Zcw+ppQjDY4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 254/482] bpftool: Fix undefined behavior caused by shifting into the sign bit
Date: Tue,  8 Oct 2024 14:05:17 +0200
Message-ID: <20241008115658.284116279@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 4cdc0e4ce5e893bc92255f5f734d983012f2bc2e ]

Replace shifts of '1' with '1U' in bitwise operations within
__show_dev_tc_bpf() to prevent undefined behavior caused by shifting
into the sign bit of a signed integer. By using '1U', the operations
are explicitly performed on unsigned integers, avoiding potential
integer overflow or sign-related issues.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20240908140009.3149781-1-visitorckw@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/net.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 968714b4c3d45..ad2ea6cf2db11 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -482,9 +482,9 @@ static void __show_dev_tc_bpf(const struct ip_devname_ifindex *dev,
 		if (prog_flags[i] || json_output) {
 			NET_START_ARRAY("prog_flags", "%s ");
 			for (j = 0; prog_flags[i] && j < 32; j++) {
-				if (!(prog_flags[i] & (1 << j)))
+				if (!(prog_flags[i] & (1U << j)))
 					continue;
-				NET_DUMP_UINT_ONLY(1 << j);
+				NET_DUMP_UINT_ONLY(1U << j);
 			}
 			NET_END_ARRAY("");
 		}
@@ -493,9 +493,9 @@ static void __show_dev_tc_bpf(const struct ip_devname_ifindex *dev,
 			if (link_flags[i] || json_output) {
 				NET_START_ARRAY("link_flags", "%s ");
 				for (j = 0; link_flags[i] && j < 32; j++) {
-					if (!(link_flags[i] & (1 << j)))
+					if (!(link_flags[i] & (1U << j)))
 						continue;
-					NET_DUMP_UINT_ONLY(1 << j);
+					NET_DUMP_UINT_ONLY(1U << j);
 				}
 				NET_END_ARRAY("");
 			}
-- 
2.43.0



