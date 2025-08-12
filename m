Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75135282E1;
	Tue, 12 Aug 2025 18:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022273; cv=none; b=HUXIFP1COPJeZaORQSssv9q9Xz//0umAD9bmY/2oE6LGljOIdtFeXrjPfPoxMqi7rFWGmaaPQZ3US94KHEISEJNUq7PiieJ4t04lQElPGTM7jBwelh80SzQ3Bd7j6Cg6/M9JkXEIFzo1CftO0bkig1qFffdpkHdMLm5htlASBVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022273; c=relaxed/simple;
	bh=Fk7azpVQSqtvabN38vwqJyl+H13w8dmmeBcxF4aVunI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdeTmfMlVD/nHytraTDDkHFyj7Awn8mb5ec1IXWhk8trLu/tYHmwi8G5LjJibQymjj46XnwmmPsnyjzGONMcq3+dVO9sk/1SdInrEIK45dpNz0lCoqoCpc9cnvw9ikqSlgpYPqKlswglXUiZGRq7pd7uja3Qzgf7Azfkrs3RA8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13NA8Kh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13NA8Kh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98782C4CEF0;
	Tue, 12 Aug 2025 18:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022273;
	bh=Fk7azpVQSqtvabN38vwqJyl+H13w8dmmeBcxF4aVunI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13NA8Kh2HFzHyadFC2GDRCkLgHBddPwLDXR8pVETCBQRd8wfI7neA2C4r/N9Oiw44
	 dnxM8V8Q5WVyrwEXpgEMeVfxzoU9Ko/bUJ6b6FIZnwRC/tSZ2VcHnDwCQGZtTZ2QXs
	 WPAD1uUeomGzm1j5jGtAFw7uNJGWQk/6b471Aoow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fushuai Wang <wangfushuai@baidu.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/369] selftests/bpf: fix signedness bug in redir_partial()
Date: Tue, 12 Aug 2025 19:26:10 +0200
Message-ID: <20250812173017.525845352@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fushuai Wang <wangfushuai@baidu.com>

[ Upstream commit 6a4bd31f680a1d1cf06492fe6dc4f08da09769e6 ]

When xsend() returns -1 (error), the check 'n < sizeof(buf)' incorrectly
treats it as success due to unsigned promotion. Explicitly check for -1
first.

Fixes: a4b7193d8efd ("selftests/bpf: Add sockmap test for redirecting partial skb data")
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Link: https://lore.kernel.org/r/20250612084208.27722-1-wangfushuai@baidu.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 4ee1148d22be..1cfed83156b0 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -924,6 +924,8 @@ static void redir_partial(int family, int sotype, int sock_map, int parser_map)
 		goto close;
 
 	n = xsend(c1, buf, sizeof(buf), 0);
+	if (n == -1)
+		goto close;
 	if (n < sizeof(buf))
 		FAIL("incomplete write");
 
-- 
2.39.5



