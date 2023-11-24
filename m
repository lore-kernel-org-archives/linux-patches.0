Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CDA2511F;
	Fri, 24 Nov 2023 19:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aesNrUiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AD4C433C7;
	Fri, 24 Nov 2023 19:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853943;
	bh=I/ZmqpcYb+0sD880xun09+KD5SlI5d36j8XczSJJ9yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aesNrUiDMXdVL/DtyCc9hTGIlPyy4CKChaZDm/l1GXvO1Eo01Rr2bY8GZQN0xJWgn
	 HaZTRf8uvg/jUfVsMqz2O8cdBuUT2fKojGDweOUfdPwLsWkrQRMqUq4U2kEeVNcGb4
	 rDiX4obK4FDFkPDIzJI2eaGLTSX/+gIPqtmLQd+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Lukas Loidolt <e1634039@student.tuwien.ac.at>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 068/159] randstruct: Fix gcc-plugin performance mode to stay in group
Date: Fri, 24 Nov 2023 17:54:45 +0000
Message-ID: <20231124171944.785943949@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 381fdb73d1e2a48244de7260550e453d1003bb8e upstream.

The performance mode of the gcc-plugin randstruct was shuffling struct
members outside of the cache-line groups. Limit the range to the
specified group indexes.

Cc: linux-hardening@vger.kernel.org
Cc: stable@vger.kernel.org
Reported-by: Lukas Loidolt <e1634039@student.tuwien.ac.at>
Closes: https://lore.kernel.org/all/f3ca77f0-e414-4065-83a5-ae4c4d25545d@student.tuwien.ac.at
Fixes: 313dd1b62921 ("gcc-plugins: Add the randstruct plugin")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -209,12 +209,14 @@ static void partition_struct(tree *field
 
 static void performance_shuffle(tree *newtree, unsigned long length, ranctx *prng_state)
 {
-	unsigned long i, x;
+	unsigned long i, x, index;
 	struct partition_group size_group[length];
 	unsigned long num_groups = 0;
 	unsigned long randnum;
 
 	partition_struct(newtree, length, (struct partition_group *)&size_group, &num_groups);
+
+	/* FIXME: this group shuffle is currently a no-op. */
 	for (i = num_groups - 1; i > 0; i--) {
 		struct partition_group tmp;
 		randnum = ranval(prng_state) % (i + 1);
@@ -224,11 +226,14 @@ static void performance_shuffle(tree *ne
 	}
 
 	for (x = 0; x < num_groups; x++) {
-		for (i = size_group[x].start + size_group[x].length - 1; i > size_group[x].start; i--) {
+		for (index = size_group[x].length - 1; index > 0; index--) {
 			tree tmp;
+
+			i = size_group[x].start + index;
 			if (DECL_BIT_FIELD_TYPE(newtree[i]))
 				continue;
-			randnum = ranval(prng_state) % (i + 1);
+			randnum = ranval(prng_state) % (index + 1);
+			randnum += size_group[x].start;
 			// we could handle this case differently if desired
 			if (DECL_BIT_FIELD_TYPE(newtree[randnum]))
 				continue;


