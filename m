Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7631CFEB2;
	Mon,  6 Jan 2025 15:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179111; cv=none; b=MB/SWIWGro55d01gcyq9Whu3SZ5DeTZTuU+feTdcjiWyGMTHZ+fOVbERry9GdjWjggGbxvmHc0KSXoJdQtutjDXKL0yXjgRdc5lr9PDLpleHh/Rr2/wuwgWLtAL8oWMvfwvsFi0W3iwJJAQDIC6B9eaB4EPftbuD0sbqbpSGotE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179111; c=relaxed/simple;
	bh=DEEraJmjaGyD1KtELpjDEKF5ZKNL1v1hMnCMk9MVjPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILO1KJHfhvgXjz/ZGvzBbki0Um9IuKj8ZlTAfjd/HtshgauI5n5fwP1wi1N1DEn/1M61GFu3w3sd344PByYW6k3vXj3G3tG3sk3a6gzNTPPxVpYlBs5d7WLZHFgUsUiy4aHYqZlpSSh6uyY+HxGxohQY2Pk0a1vpmKt1BaCWRpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwHr8Qp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwHr8Qp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D0DC4CED6;
	Mon,  6 Jan 2025 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179111;
	bh=DEEraJmjaGyD1KtELpjDEKF5ZKNL1v1hMnCMk9MVjPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwHr8Qp7Bk83/6rUobWhiE4XOMKRom24ycSkSqo17Z0yck4BQGvrOrkAQTHivB4WA
	 aPous+atinEo1pg4xEugaNw8603nvbsVsPBs44FLWIj/kX7ePkU8yQR3ktnvoXlr9x
	 NyTrkpmOsfw3cGsLwTmqKfpEGIX5gKGVQICmFPLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.4 31/93] of: Fix error path in of_parse_phandle_with_args_map()
Date: Mon,  6 Jan 2025 16:17:07 +0100
Message-ID: <20250106151129.878948618@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit d7dfa7fde63dde4d2ec0083133efe2c6686c03ff upstream.

The current code uses some 'goto put;' to cancel the parsing operation
and can lead to a return code value of 0 even on error cases.

Indeed, some goto calls are done from a loop without setting the ret
value explicitly before the goto call and so the ret value can be set to
0 due to operation done in previous loop iteration. For instance match
can be set to 0 in the previous loop iteration (leading to a new
iteration) but ret can also be set to 0 it the of_property_read_u32()
call succeed. In that case if no match are found or if an error is
detected the new iteration, the return value can be wrongly 0.

Avoid those cases setting the ret value explicitly before the goto
calls.

Fixes: bd6f2fd5a1d5 ("of: Support parsing phandle argument lists through a nexus node")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20241202165819.158681-1-herve.codina@bootlin.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1695,8 +1695,10 @@ int of_parse_phandle_with_args_map(const
 			map_len--;
 
 			/* Check if not found */
-			if (!new)
+			if (!new) {
+				ret = -EINVAL;
 				goto put;
+			}
 
 			if (!of_device_is_available(new))
 				match = 0;
@@ -1706,17 +1708,20 @@ int of_parse_phandle_with_args_map(const
 				goto put;
 
 			/* Check for malformed properties */
-			if (WARN_ON(new_size > MAX_PHANDLE_ARGS))
-				goto put;
-			if (map_len < new_size)
+			if (WARN_ON(new_size > MAX_PHANDLE_ARGS) ||
+			    map_len < new_size) {
+				ret = -EINVAL;
 				goto put;
+			}
 
 			/* Move forward by new node's #<list>-cells amount */
 			map += new_size;
 			map_len -= new_size;
 		}
-		if (!match)
+		if (!match) {
+			ret = -ENOENT;
 			goto put;
+		}
 
 		/* Get the <list>-map-pass-thru property (optional) */
 		pass = of_get_property(cur, pass_name, NULL);


