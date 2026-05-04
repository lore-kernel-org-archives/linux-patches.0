Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5A83D9029;
	Mon,  4 May 2026 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903737; cv=none; b=e1vXfnPlSnQOsUhd7rTl4OZATxSSAm8xVoWPmc2xEKIWuEHSs4DFpd53p4NMHT5twC6eCdxdfZVqtbr/LjX4Nn5yGjU597g6pdM7EQidiSnmrWZCl1/PIc94JA2Rh12q03WiZf/1obGmcvdbKV8P79X60WaWkCAUkrafs9OaSG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903737; c=relaxed/simple;
	bh=4dPFEwQA/k9Vr4zyyZWu7SvWI4UMbTYfZiYPzM4HPSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5w2gESh9XeuwiB6dDT2V5YUivD0oBqd01arm7Wr74QltcbMEOeOuWo5oAFlWgswTjPW+oNkq5oLjsXCRQ6nsuvBzZjghszFPCNfkoKC6x2ag4aeAflqdq/FLh7PyaY2zq42m0B49NPzlW9XUOhbZhQlh3RWw8PhKc4GDVqWTYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEhYrKtS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEhYrKtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0436EC2BCB8;
	Mon,  4 May 2026 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903737;
	bh=4dPFEwQA/k9Vr4zyyZWu7SvWI4UMbTYfZiYPzM4HPSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEhYrKtS9pDdjQgb7RcLnN6tuEypH8OObcgrHTIXbABLuv3RMDKD8XHhqKSiVMyQC
	 rR7TwB1hgHGQxf5fKhlR1mtHmrQCaO4KmKyxh51s+QpJYNsTSDqv19vPQDxAt3BlGM
	 vWwIK6YHZp/luLjNUAR6IVCyRKTnRNpe1le3pP/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 042/275] of: unittest: fix use-after-free in of_unittest_changeset()
Date: Mon,  4 May 2026 15:49:42 +0200
Message-ID: <20260504135144.503833157@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit faecdd423c27f0d6090156a435ba9dbbac0eaddb upstream.

The variable 'parent' is assigned the value of 'nchangeset' earlier in the
function, meaning both point to the same struct device_node. The call to
of_node_put(nchangeset) can decrement the reference count to zero and
free the node if there are no other holders. After that, the code still
uses 'parent' to check for the presence of a property and to read a
string property, leading to a use-after-free.

Fix this by moving the of_node_put() call after the last access to
'parent', avoiding the UAF.

Fixes: 1c668ea65506 ("of: unittest: Use of_property_present()")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260409022233.418103-1-vulab@iscas.ac.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/unittest.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -896,8 +896,6 @@ static void __init of_unittest_changeset
 
 	unittest(!of_changeset_apply(&chgset), "apply failed\n");
 
-	of_node_put(nchangeset);
-
 	/* Make sure node names are constructed correctly */
 	unittest((np = of_find_node_by_path("/testcase-data/changeset/n2/n21")),
 		 "'%pOF' not added\n", n21);
@@ -919,6 +917,7 @@ static void __init of_unittest_changeset
 	if (!ret)
 		unittest(strcmp(propstr, "hello") == 0, "original value not in updated property after revert");
 
+	of_node_put(nchangeset);
 	of_changeset_destroy(&chgset);
 
 	of_node_put(n1);


