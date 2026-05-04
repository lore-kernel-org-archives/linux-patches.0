Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487B43D8129;
	Mon,  4 May 2026 14:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904432; cv=none; b=bjw69G6vfijxQCjytoIVkbjtqrvsA6oZE4mlgJGXIyqU6DqHNtq8XswdqlQ8KGlEHGY6YzP1dOcvWc1tFkh2GjWznKF5jY4Ygpbb05y0H0ljhQIYYfqauUANEpp0cKD0UszVRALYLiosVrRT8UCJ3OjvJebsnWSvlp9S/jxKgWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904432; c=relaxed/simple;
	bh=P1io+hU3SXDuBcc3EvDZOGIO8gjqDjHXXOpRy7QIrIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTSvQd1DADuA68yePzyVU+zaYpGYcsr1Dd81U2BIOO66az3A/JKaCB2zlB3n2degRyks0gbo3bKTvbfxoCHz46Fdgcp2/h/FWkLB6pKVyhr4ussjt7SFp35Dj09/pwvYXOMGo56pFs3XKhw80YnhRHOw5fZZIHWz/WjJUcj0pao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIBwJDef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIBwJDef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35DFC2BCB8;
	Mon,  4 May 2026 14:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904432;
	bh=P1io+hU3SXDuBcc3EvDZOGIO8gjqDjHXXOpRy7QIrIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIBwJDefS+tnCv8pG7Kys9bg3w8J/XinUAAghVDTMlo5h39q4fMV8uBH13HpIg7nC
	 LX+fZfVkHO3HUAeld+ioXf82ZvcB4RPDi95R3hpAYm7D7Z9NCARqJaruvB5B2ADUkO
	 q8JPtWKdieeRs6jmi8RaH/zNuURJ7pIt3qjNV3TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 037/215] of: unittest: fix use-after-free in of_unittest_changeset()
Date: Mon,  4 May 2026 15:50:56 +0200
Message-ID: <20260504135131.533241189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -887,8 +887,6 @@ static void __init of_unittest_changeset
 
 	unittest(!of_changeset_apply(&chgset), "apply failed\n");
 
-	of_node_put(nchangeset);
-
 	/* Make sure node names are constructed correctly */
 	unittest((np = of_find_node_by_path("/testcase-data/changeset/n2/n21")),
 		 "'%pOF' not added\n", n21);
@@ -910,6 +908,7 @@ static void __init of_unittest_changeset
 	if (!ret)
 		unittest(strcmp(propstr, "hello") == 0, "original value not in updated property after revert");
 
+	of_node_put(nchangeset);
 	of_changeset_destroy(&chgset);
 
 	of_node_put(n1);


