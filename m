Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC9B2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BD5C433EF;
	Wed, 12 Apr 2023 08:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289603;
	bh=NT8zZTzLMcevEZDJVAuYuUFPgeIwvCBtbsx32sxwWec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSdVPf4Sl5r/6jsJKyN37UvyH0osHJQMJee299uZ7t17haSuJptLDvpB2hGISGdV6
	 VemdDdWTUckGY/Nnsg7EJqlllUWxkTcN0NTbNVUqbBMRSyXB02aC8ZPHfFx2hMtREB
	 DExxG1tzn32B6Vk+kKfaCNrue2obt8B5WsN0G+bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.2 163/173] maple_tree: reduce user error potential
Date: Wed, 12 Apr 2023 10:34:49 +0200
Message-Id: <20230412082844.730111546@linuxfoundation.org>
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

commit 50e81c82ad947045c7ed26ddc9acb17276b653b6 upstream.

When iterating, a user may operate on the tree and cause the maple state
to be altered and left in an unintuitive state.  Detect this scenario and
correct it by setting to the limit and invalidating the state.

Link: https://lkml.kernel.org/r/20230120162650.984577-4-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4736,6 +4736,11 @@ static inline void *mas_next_entry(struc
 	unsigned long last;
 	enum maple_type mt;
 
+	if (mas->index > limit) {
+		mas->index = mas->last = limit;
+		mas_pause(mas);
+		return NULL;
+	}
 	last = mas->last;
 retry:
 	offset = mas->offset;
@@ -4842,6 +4847,11 @@ static inline void *mas_prev_entry(struc
 {
 	void *entry;
 
+	if (mas->index < min) {
+		mas->index = mas->last = min;
+		mas_pause(mas);
+		return NULL;
+	}
 retry:
 	while (likely(!mas_is_none(mas))) {
 		entry = mas_prev_nentry(mas, min, mas->index);


