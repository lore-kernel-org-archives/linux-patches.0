Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783EB281369;
	Thu, 13 Feb 2025 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457825; cv=none; b=cYtTw78jsP1ihhwvX8PRYdu2jUL76QIMRRgStnS1jk4BQWF2WhWTGExw344ocDi+QCbjBieJFk4BUn6kQlsloFTPEKBNDYNn/n7TEKGDD+n4oeq88xQmFITuUZxuEYAGaA5s4lav2508Trg8Tn89vvh8tYH7FnOnFnWry+vBsWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457825; c=relaxed/simple;
	bh=ZReJ1Rdg0YjU7Q5FepkAsUU9wF1eN49UKlUsUPsnosQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp/BL5gVlO7wyWkjMSeJzQxhsvyqbCojNJls5WczMLuKreoq1jO9kB65rqClGLTo31hGxqYyq6h5fuZomoMMx7lJDA8YfDn0eMoQP2WUOLzncmiMPYQL0NjI2y7YkXNOTIHTnspRF/pxjgvHacrGI+Cot69zlEQh4Q0g8ug7/Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5fLNN19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5fLNN19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE66C4CED1;
	Thu, 13 Feb 2025 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457825;
	bh=ZReJ1Rdg0YjU7Q5FepkAsUU9wF1eN49UKlUsUPsnosQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5fLNN19H5ax3C6kWZyIGmDTNLEPySnWqQc3NylTAdZmGElLlVfa9qC64r5k7Vz4Z
	 eER0P2zCQOaKSAyYpLhlk1EpH7tXetDrBUhJyCnf3d1CM4F7F+WL7lPFmZshIsjJnz
	 i1AzKGfvdAtnrDDe7I6tREy7jMjGyQxCgqOsMpA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 196/422] of: Fix of_find_node_opts_by_path() handling of alias+path+options
Date: Thu, 13 Feb 2025 15:25:45 +0100
Message-ID: <20250213142444.108438834@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit b9e58c934c56aa35b0fb436d9afd86ef326bae0e upstream.

of_find_node_opts_by_path() fails to find OF device node when its
@path parameter have pattern below:

"alias-name/node-name-1/.../node-name-N:options".

The reason is that alias name length calculated by the API is wrong, as
explained by example below:

"testcase-alias/phandle-tests/consumer-a:testaliasoption".
 ^             ^                        ^
 0             14                       39

The right length of alias 'testcase-alias' is 14, but the result worked
out by the API is 39 which is obvious wrong.

Fix by using index of either '/' or ':' as the length who comes earlier.

Fixes: 75c28c09af99 ("of: add optional options parameter to of_find_node_by_path()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241216-of_core_fix-v2-1-e69b8f60da63@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -841,10 +841,10 @@ struct device_node *of_find_node_opts_by
 	/* The path could begin with an alias */
 	if (*path != '/') {
 		int len;
-		const char *p = separator;
+		const char *p = strchrnul(path, '/');
 
-		if (!p)
-			p = strchrnul(path, '/');
+		if (separator && separator < p)
+			p = separator;
 		len = p - path;
 
 		/* of_aliases must not be NULL */


