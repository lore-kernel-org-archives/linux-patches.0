Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66F41DE8A0;
	Tue,  8 Oct 2024 12:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392193; cv=none; b=UJ8Znm3uoWSfaSa3oUjLOY5owpTQm1PMTangaWSa9RfkuM8Bdc1Flp7FYxEZ+QAdoq3zvHQSeALIDD3p7YYEW/dR0Obut+rjOyJ5Jh8AY2hTbWCvNm0Bqn7GHsj5ApVaIaSthPvnScrnF9IqxVhqxeFBAONCqPOaZkF3mWtc80U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392193; c=relaxed/simple;
	bh=ku9t2aQRmZbFRGH0rWjHs+tnC+Wj4N/4wIdsfLQs3mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlIH5qEskKr2txYqTZ6LTmNbYtYPB4XyighIrxgsFrQrwowfTd5H5o9lvSfE/prgEv8vv7uEaX4H03Q5ERd9PjI+S8WR3XnNDLkpEVmNWfN0zn0+3wujTIrBLQoSBaJAvRzuSdmo3lWgcAO/4Yc3hYJtf8r4hQDMHyaJLehHwWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM1QtpeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM1QtpeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC57C4CEC7;
	Tue,  8 Oct 2024 12:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392193;
	bh=ku9t2aQRmZbFRGH0rWjHs+tnC+Wj4N/4wIdsfLQs3mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LM1QtpeT6I8a0w8IfrVOdPBEy5+4myBmo0lAiTIlErswlAIycmMFzRBsOgHRH4cDJ
	 z/WyqhqH4Qwxed+kMzrB282bFxYQ1A2evaDP4ykNyRuDoVAyKuNr4Eaj77Mnai/Yne
	 1cetzfskGsEsjI0kN8RvZIwdC+FbDTFcwLDWOt5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 312/558] bpftool: Fix undefined behavior in qsort(NULL, 0, ...)
Date: Tue,  8 Oct 2024 14:05:42 +0200
Message-ID: <20241008115714.589546049@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit f04e2ad394e2755d0bb2d858ecb5598718bf00d5 ]

When netfilter has no entry to display, qsort is called with
qsort(NULL, 0, ...). This results in undefined behavior, as UBSan
reports:

net.c:827:2: runtime error: null pointer passed as argument 1, which is declared to never be null

Although the C standard does not explicitly state whether calling qsort
with a NULL pointer when the size is 0 constitutes undefined behavior,
Section 7.1.4 of the C standard (Use of library functions) mentions:

"Each of the following statements applies unless explicitly stated
otherwise in the detailed descriptions that follow: If an argument to a
function has an invalid value (such as a value outside the domain of
the function, or a pointer outside the address space of the program, or
a null pointer, or a pointer to non-modifiable storage when the
corresponding parameter is not const-qualified) or a type (after
promotion) not expected by a function with variable number of
arguments, the behavior is undefined."

To avoid this, add an early return when nf_link_info is NULL to prevent
calling qsort with a NULL pointer.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20240910150207.3179306-1-visitorckw@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index ad2ea6cf2db11..0f2106218e1f0 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -824,6 +824,9 @@ static void show_link_netfilter(void)
 		nf_link_count++;
 	}
 
+	if (!nf_link_info)
+		return;
+
 	qsort(nf_link_info, nf_link_count, sizeof(*nf_link_info), netfilter_link_compar);
 
 	for (id = 0; id < nf_link_count; id++) {
-- 
2.43.0



