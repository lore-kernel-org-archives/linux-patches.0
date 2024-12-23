Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34A517A597;
	Mon, 23 Dec 2024 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970576; cv=none; b=F6Z70BhzAnIf7yt0st3ajKc1q9Rdfa5VIV1A5jevy/3I2jDfzJmWHzzcR8rnbwcT1hhFMgWrgKtwZC4Tv4mTT4Wgu7eEPg3GMEk3qqjAAy3qlSjos+R9srt9Vc1y5NxJstfrKFPGuUUGHgXB8Pe/oAi8RfviscfUm+uEFd3eoS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970576; c=relaxed/simple;
	bh=TBljgT/Q5qv42jGW6MDn/3TtydqfJYDfi1AqnDFQe+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjFmiFnRtly45xriKqohzs2v+W/eJdqlUW3N8YyOMrjnDs/pn1f76E/xy9hMMgjXF8fuxy0JtzRfnhL11EyrK0tDp7G8v3tN4rUDJhlZFvrWKbAINE8lquPc8cjq7DxP7VXPediE3+Wiimkgqu2BA3MgWRuzflioL+qAHuaOr6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdVoQu7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdVoQu7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1338CC4CED3;
	Mon, 23 Dec 2024 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970576;
	bh=TBljgT/Q5qv42jGW6MDn/3TtydqfJYDfi1AqnDFQe+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdVoQu7dhLP1IIz/r8F0kSJgn94J0FhPAyFw73uoRoRYZd+LYG8ve/BF9clVZ+NfS
	 LRE0y28n0Q/zeY+OclJUdpBV4TFdC2poT4dwT6B0SRAQkb+p3yJ7ST4gFtcGng6jqC
	 v7rNJlJx+MigEsYoDkOK1wRyyB8E/hMTVaDYyb4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 105/116] of: Fix error path in of_parse_phandle_with_args_map()
Date: Mon, 23 Dec 2024 16:59:35 +0100
Message-ID: <20241223155403.633543985@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1415,8 +1415,10 @@ int of_parse_phandle_with_args_map(const
 			map_len--;
 
 			/* Check if not found */
-			if (!new)
+			if (!new) {
+				ret = -EINVAL;
 				goto put;
+			}
 
 			if (!of_device_is_available(new))
 				match = 0;
@@ -1426,17 +1428,20 @@ int of_parse_phandle_with_args_map(const
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


