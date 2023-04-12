Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A90B2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5272C433D2;
	Wed, 12 Apr 2023 08:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289606;
	bh=qkhMdaykMPB99hz5u2spnrvMhFU5FntukwCVgPAWZPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEwKmCZOSlA4jvXUwP6FnSpVBFWB+pLC3AXRzrB9bKDRtzWk0B8djAQ71rkABMpcy
	 pBa9gJ+jc7KtZ7HQ8unhyC8a1n4tRhhtMSgak7Mf5mfVMIyFMRh9XrHFHZ+9jZbQ8s
	 BRSytHQX7MMBFhL7PROIrukn0EUNtvWsVgfDLu1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 6.2 164/173] maple_tree: fix handle of invalidated state in mas_wr_store_setup()
Date: Wed, 12 Apr 2023 10:34:50 +0200
Message-Id: <20230412082844.770247627@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 1202700c3f8cc5f7e4646c3cf05ee6f7c8bc6ccf upstream.

If an invalidated maple state is encountered during write, reset the maple
state to MAS_START.  This will result in a re-walk of the tree to the
correct location for the write.

Link: https://lore.kernel.org/all/20230107020126.1627-1-sj@kernel.org/
Link: https://lkml.kernel.org/r/20230120162650.984577-6-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5599,6 +5599,9 @@ static inline void mte_destroy_walk(stru
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
 {
+	if (unlikely(mas_is_paused(wr_mas->mas)))
+		mas_reset(wr_mas->mas);
+
 	if (!mas_is_start(wr_mas->mas)) {
 		if (mas_is_none(wr_mas->mas)) {
 			mas_reset(wr_mas->mas);


