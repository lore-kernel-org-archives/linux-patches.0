Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284B714288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3pPDVWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97430C433C8;
	Mon, 16 Oct 2023 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467934;
	bh=dc0Z7knpU2vGrhBpVbTCnV6LI1HHMcT/5GCZwZDFu7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3pPDVWS/IJcj2wkMxYQfAG9qmO+0/edOQ733jgqlVHBozIy0g77Y8wV47LC3PFVw
	 pJy/R1OTz51GXqCBJ+RYMMA/pFNgarNIUj8sLFB/Syao2FPx+V/0uqWl1Cbq8ZuBG+
	 t4oMbuqKErTInaQl+r6A9/yjNb7XgiynDCcTL5xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.5 093/191] ovl: temporarily disable appending lowedirs
Date: Mon, 16 Oct 2023 10:41:18 +0200
Message-ID: <20231016084017.565732209@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit beae836e9c61ee039e367a94b14f7fea08f0ad4c upstream.

Kernel v6.5 converted overlayfs to new mount api.
As an added bonus, it also added a feature to allow appending lowerdirs
using lowerdir=:/lower2,lowerdir=::/data3 syntax.

This new syntax has raised some concerns regarding escaping of colons.
We decided to try and disable this syntax, which hasn't been in the wild
for so long and introduce it again in 6.7 using explicit mount options
lowerdir+=/lower2,datadir+=/data3.

Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/r/CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com/
Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/params.c |   52 ++------------------------------------------------
 1 file changed, 3 insertions(+), 49 deletions(-)

--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -284,12 +284,6 @@ static void ovl_parse_param_drop_lowerdi
  *     Set "/lower1", "/lower2", and "/lower3" as lower layers and
  *     "/data1" and "/data2" as data lower layers. Any existing lower
  *     layers are replaced.
- * (2) lowerdir=:/lower4
- *     Append "/lower4" to current stack of lower layers. This requires
- *     that there already is at least one lower layer configured.
- * (3) lowerdir=::/lower5
- *     Append data "/lower5" as data lower layer. This requires that
- *     there's at least one regular lower layer present.
  */
 static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 {
@@ -311,49 +305,9 @@ static int ovl_parse_param_lowerdir(cons
 		return 0;
 	}
 
-	if (strncmp(name, "::", 2) == 0) {
-		/*
-		 * This is a data layer.
-		 * There must be at least one regular lower layer
-		 * specified.
-		 */
-		if (ctx->nr == 0) {
-			pr_err("data lower layers without regular lower layers not allowed");
-			return -EINVAL;
-		}
-
-		/* Skip the leading "::". */
-		name += 2;
-		data_layer = true;
-		/*
-		 * A data layer is automatically an append as there
-		 * must've been at least one regular lower layer.
-		 */
-		append = true;
-	} else if (*name == ':') {
-		/*
-		 * This is a regular lower layer.
-		 * If users want to append a layer enforce that they
-		 * have already specified a first layer before. It's
-		 * better to be strict.
-		 */
-		if (ctx->nr == 0) {
-			pr_err("cannot append layer if no previous layer has been specified");
-			return -EINVAL;
-		}
-
-		/*
-		 * Once a sequence of data layers has started regular
-		 * lower layers are forbidden.
-		 */
-		if (ctx->nr_data > 0) {
-			pr_err("regular lower layers cannot follow data lower layers");
-			return -EINVAL;
-		}
-
-		/* Skip the leading ":". */
-		name++;
-		append = true;
+	if (*name == ':') {
+		pr_err("cannot append lower layer");
+		return -EINVAL;
 	}
 
 	dup = kstrdup(name, GFP_KERNEL);


