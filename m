Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7332E41B34E;
	Wed,  4 Feb 2026 14:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217043; cv=none; b=X69rbwFCSgntIYEEdQj60Wy8c44/vLBO5ruh3jhazz+0rBzN5AaiINg7TL5lgC04/1V/ga0Ub+82L3oNdhDmmCcocoeHSgmM5pbLRJB+dhXwzoug4Vb320RqjbGsWZihot3pLoEMjN6y+SSgaYfJr30pq+WfJ14hfLMGjsw8/NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217043; c=relaxed/simple;
	bh=+U753IKr8Ucm76H0tiazudaWcSAAklV0ggiJEVMZ/Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkdprGdyc3b+ec6fZGTxWiT/fiSg1lEZaRuHmF8hy+vuTXbuNYscq/q3QDAnLdcBY+IhYDnGreHNvE4lcQVh25B1g0m9K2W2uTxLypJrXENS9emr5pgr7bxiL9yIKhXPPZSym1cKxj+Z5IUMTJSuAUt8cQ4INRDvmNKav4bi4Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Re5KxcRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Re5KxcRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CB1C4CEF7;
	Wed,  4 Feb 2026 14:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217043;
	bh=+U753IKr8Ucm76H0tiazudaWcSAAklV0ggiJEVMZ/Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Re5KxcROrAODl/7ipqbE5le4kA1fIwCo3sIBfxUd2mI51Ssb4MddMDLtq/N01iE+p
	 nOCz+TZ0Q6bqoDtBwC0ff080A1O7ME10DYeFB9F5kkSD0yme2xP4gwjpAeLEWZj6Qb
	 vLewMYBCzRD5DwAyUkrUBOcEtGDq+brqfqGLPs00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 107/206] of: fix reference count leak in of_alias_scan()
Date: Wed,  4 Feb 2026 15:38:58 +0100
Message-ID: <20260204143902.062765487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

commit 81122fba08fa3ccafab6ed272a5c6f2203923a7e upstream.

of_find_node_by_path() returns a device_node with its refcount
incremented. When kstrtoint() fails or dt_alloc() fails, the function
continues to the next iteration without calling of_node_put(), causing
a reference count leak.

Add of_node_put(np) before continue on both error paths to properly
release the device_node reference.

Fixes: 611cad720148 ("dt: add of_alias_scan and of_alias_get_id")
Cc: stable@vger.kernel.org
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Link: https://patch.msgid.link/20260117091238.481243-1-geoffreyhe2@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2018,13 +2018,17 @@ void of_alias_scan(void * (*dt_alloc)(u6
 			end--;
 		len = end - start;
 
-		if (kstrtoint(end, 10, &id) < 0)
+		if (kstrtoint(end, 10, &id) < 0) {
+			of_node_put(np);
 			continue;
+		}
 
 		/* Allocate an alias_prop with enough space for the stem */
 		ap = dt_alloc(sizeof(*ap) + len + 1, __alignof__(*ap));
-		if (!ap)
+		if (!ap) {
+			of_node_put(np);
 			continue;
+		}
 		memset(ap, 0, sizeof(*ap) + len + 1);
 		ap->alias = start;
 		of_alias_add(ap, np, id, start, len);


