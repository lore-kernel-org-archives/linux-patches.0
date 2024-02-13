Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2377FA93C;
	Tue, 13 Feb 2024 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845989; cv=none; b=ZEBuS8E0/uSvGYxG3NpmTj8nIWOudKp3zaQQrLZVo4CUVFdRmkQ6wL27wo00NfsmHPuW+hueKvTdr3FKtiNl9lsUEyGRgPrAj84Mzg2ai/xeqipmq08x5P4mfOEmQ9R4JEc6x5apC5p+GNE50E9YCBFHSmWSjN6q4Ab+Hp/DqgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845989; c=relaxed/simple;
	bh=WqciRkJFRN33gNk82wn6UGlIanvuVJud/3sQ9xl0Oe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiuskwmNsXXKOEGljbQ5xDef2CMr2zH/SAkbh/aF3aQMlrn/nXiuAh+2sUKRYWwsRI+/9J3475mT/HYV1fBj7B68A0yYnOznJFInjo68kqd6rroBP8hc9zE23vq1/N/+h1TruZgapIt+8n7JMzzNCpIS7pessxbMu5fPlsXuo1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEXx9t6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEXx9t6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D08C433C7;
	Tue, 13 Feb 2024 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845989;
	bh=WqciRkJFRN33gNk82wn6UGlIanvuVJud/3sQ9xl0Oe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEXx9t6VBQ6IahoeZAhIqjNzywEaVrvZXqOHDPtF/E/al+r8PDuVYYrnae4cca5Bd
	 DtDlf9+tdoooX7mS3eqlehXqDUjHPIU4UiFciJt3pFVQzD0nUFoWy3wABrVoCiOGl8
	 30LQNUBNhZzkBr+3P+TjZrq4kRpShWMzlUc4nC0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.7 112/124] bcachefs: Dont pass memcmp() as a pointer
Date: Tue, 13 Feb 2024 18:22:14 +0100
Message-ID: <20240213171857.002790594@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 0124f42da70c513dc371b73688663c54e5a9666f upstream.

Some (buggy!) compilers have issues with this.

Fixes: https://github.com/koverstreet/bcachefs/issues/625
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/replicas.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/bcachefs/replicas.c
+++ b/fs/bcachefs/replicas.c
@@ -9,6 +9,12 @@
 static int bch2_cpu_replicas_to_sb_replicas(struct bch_fs *,
 					    struct bch_replicas_cpu *);
 
+/* Some (buggy!) compilers don't allow memcmp to be passed as a pointer */
+static int bch2_memcmp(const void *l, const void *r, size_t size)
+{
+	return memcmp(l, r, size);
+}
+
 /* Replicas tracking - in memory: */
 
 static void verify_replicas_entry(struct bch_replicas_entry *e)
@@ -33,7 +39,7 @@ void bch2_replicas_entry_sort(struct bch
 
 static void bch2_cpu_replicas_sort(struct bch_replicas_cpu *r)
 {
-	eytzinger0_sort(r->entries, r->nr, r->entry_size, memcmp, NULL);
+	eytzinger0_sort(r->entries, r->nr, r->entry_size, bch2_memcmp, NULL);
 }
 
 static void bch2_replicas_entry_v0_to_text(struct printbuf *out,
@@ -833,7 +839,7 @@ static int bch2_cpu_replicas_validate(st
 	sort_cmp_size(cpu_r->entries,
 		      cpu_r->nr,
 		      cpu_r->entry_size,
-		      memcmp, NULL);
+		      bch2_memcmp, NULL);
 
 	for (i = 0; i < cpu_r->nr; i++) {
 		struct bch_replicas_entry *e =


