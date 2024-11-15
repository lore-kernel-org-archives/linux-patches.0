Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D8618950A;
	Fri, 15 Nov 2024 06:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653223; cv=none; b=ew96dGSPThNAadDb+mF7PUpcoMhVn2U6+TSOak9Y9qb7hk/8LEGJJEDFsga2mqkDpc+tnKc10pZQ9G5l4C9OHmOv3EHpxTnQHbUu/A8cU3QF0x+stgHCYdrNPDpsa00kgrEuaUcfhMQWx4vf756GU0rM78AbNg94xIU7UNadIGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653223; c=relaxed/simple;
	bh=E5Cw4wEink+gVeZNypTjqJRTZqBswjHWrUsOy0E/bro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDAZHY/ndbR6SHSnMai1/gxSzwlHHQ5KTZ8Ao+cvwNDSp9GiioTwIc35cNMXvy5GByUHoKWjnAj57kxtNr235aZW+Cx591KQNCc3sbpeGkxgKjwmPPknw3Ao+zy5VfZqQqFbTWt5EGWsKq28j+Lgrm2a+XMXy/d61uCPh/xQ/ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rV6TeflF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rV6TeflF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2CDC4CED7;
	Fri, 15 Nov 2024 06:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653223;
	bh=E5Cw4wEink+gVeZNypTjqJRTZqBswjHWrUsOy0E/bro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rV6TeflF+F5+KV4VnqMpe/myqsP5QkcESQejoL110hORLUK80nkIYTJw+TOIl4nv4
	 UBl2dPr+B+TGHGuI0+fI4byHq2piWcC5ITB384pGZ/hURXnPp9dLsZHPHMPIUd221P
	 32lPTGCoe37Tm000JfGWoq3pZ4eIWeKOeQQMQUG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrone Wu <wudevelops@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 22/63] selftests/bpf: Assert link info uprobe_multi count & path_size if unset
Date: Fri, 15 Nov 2024 07:37:45 +0100
Message-ID: <20241115063726.721733187@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyrone Wu <wudevelops@gmail.com>

[ Upstream commit b836cbdf3b81a4a22b3452186efa2e5105a77e10 ]

Add assertions in `bpf_link_info.uprobe_multi` test to verify that
`count` and `path_size` fields are correctly populated when the fields
are unset.

This tests a previous bug where the `path_size` field was not populated
when `path` and `path_size` were unset.

Signed-off-by: Tyrone Wu <wudevelops@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241011000803.681190-2-wudevelops@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/fill_link_info.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
index 745c5ada4c4bf..d50cbd8040d45 100644
--- a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
+++ b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
@@ -420,6 +420,15 @@ verify_umulti_link_info(int fd, bool retprobe, __u64 *offsets,
 	if (!ASSERT_NEQ(err, -1, "readlink"))
 		return -1;
 
+	memset(&info, 0, sizeof(info));
+	err = bpf_link_get_info_by_fd(fd, &info, &len);
+	if (!ASSERT_OK(err, "bpf_link_get_info_by_fd"))
+		return -1;
+
+	ASSERT_EQ(info.uprobe_multi.count, 3, "info.uprobe_multi.count");
+	ASSERT_EQ(info.uprobe_multi.path_size, strlen(path) + 1,
+		  "info.uprobe_multi.path_size");
+
 	for (bit = 0; bit < 8; bit++) {
 		memset(&info, 0, sizeof(info));
 		info.uprobe_multi.path = ptr_to_u64(path_buf);
-- 
2.43.0



