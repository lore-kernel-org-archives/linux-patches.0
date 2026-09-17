Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB0D5372D8;
	Thu, 17 Sep 2026 17:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664559; cv=none; b=Y26pEl7OKc8/7MAFvSWRsdWM1n1xBmkQjFs8GPxcNV2CSjXpxrZsFdTSa5uVM5HXc5zE80EsCfpsw8EW5KTslIBgAQhLsAEcpWG4GdzT9z6x/EJOlt3vuRCuoVQU3wkngWBNOVxzx37JP/ZoeTYPm0d0ix3iiNzl/S5ERlmRdk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664559; c=relaxed/simple;
	bh=2kficQas1ZwMO/0o/bWpuvpuFHqAs+cYqrM+3l56vk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J/vhf9nHK+JWicBB/V7u0d0sYQMeDEN5v+rvXnEuKgfhFIckqYV5D1QpEXu0aJDXrT5frW1uCczD8EpFUN81dmKGNeXcA+s4/qjAjZiPyuKqm1QLp01SU1MsqgmGMxKW3TrpWwTaGxUcZuVRZV9qgpIUIG3y3D9MIZkYnV6E1nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mX28NngH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mX28NngH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4B81F000FF;
	Thu, 17 Sep 2026 17:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664558;
	bh=spFHGWWFHC5Fc9DpGxYz66q8Bw+PEcXKEBxwn+LbVbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mX28NngHW+yy4Dodr5zQxrMxPfIj1uKgzu3sM4jxSjOAtu7izgHsBU09qmdCSk2xm
	 +YrbTSODmKlBaPIPIZbSBCQjATSveLeEjmMUQHbhF34FJxvnGj4FaDPP+DlLQvXbps
	 9pVgm+/e0QPzBwVg/kKX3jGqf+P9jrIrs9RAKvTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0412/1250] apparmor: propagate -ENOMEM correctly in unpack_table
Date: Thu, 17 Sep 2026 16:03:27 +0100
Message-ID: <20260917151603.190408727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 1c8a839442823ce5c627d645730d8c61d828aafa ]

Currently, if the `kvzalloc` in `unpack_table` fails, it returns NULL.
This is masked by `aa_dfa_unpack` which interprets NULL as a -EPROTO,
leading to confusing error messages in `apparmor_parser` [1].

The fixed behavior correctly propagates -ENOMEM on allocation failure.

Link: https://gitlab.com/apparmor/apparmor/-/issues/592
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/match.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index 0de249725efbf..b2a4bee4e3939 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -27,13 +27,13 @@
  * @blob: data to unpack (NOT NULL)
  * @bsize: size of blob
  *
- * Returns: pointer to table else NULL on failure
+ * Returns: pointer to table else ERR_PTR on failure
  *
  * NOTE: must be freed by kvfree (not kfree)
  */
 static struct table_header *unpack_table(char *blob, size_t bsize)
 {
-	struct table_header *table = NULL;
+	struct table_header *table = ERR_PTR(-EPROTO);
 	struct table_header th;
 	size_t tsize;
 
@@ -74,20 +74,21 @@ static struct table_header *unpack_table(char *blob, size_t bsize)
 		else if (th.td_flags == YYTD_DATA32)
 			UNPACK_ARRAY(table->td_data, blob, th.td_lolen,
 				     u32, __be32, get_unaligned_be32);
-		else
-			goto fail;
+		else {
+			kvfree(table);
+			table = ERR_PTR(-EPROTO);
+			goto out;
+		}
 		/* if table was vmalloced make sure the page tables are synced
 		 * before it is used, as it goes live to all cpus.
 		 */
 		if (is_vmalloc_addr(table))
 			vm_unmap_aliases();
-	}
+	} else
+		table = ERR_PTR(-ENOMEM);
 
 out:
 	return table;
-fail:
-	kvfree(table);
-	return NULL;
 }
 
 /**
@@ -359,8 +360,11 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
 
 	while (size > 0) {
 		table = unpack_table(data, size);
-		if (!table)
+		if (IS_ERR(table)) {
+			error = PTR_ERR(table);
+			table = NULL;
 			goto fail;
+		}
 
 		switch (table->td_id) {
 		case YYTD_ID_ACCEPT:
-- 
2.53.0



