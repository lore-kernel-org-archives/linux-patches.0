Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8A229BD9A;
	Mon,  4 May 2026 13:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902956; cv=none; b=mmdkn1XaCiV8w5cMnBa0pXzDbjMUb8VOjsBz28l1vzpGJiBa7Ii1kbuzI0GmpbQUfXwINcCrThFLG3aWe3GEctMdmKHmh0REMOd5bYwHm0bI/VsB/CNi8X2hFj1k2XZxjPxIF4OtJDiwSbkDjN2KPYLR31i5f5YYM3HyXcBd+ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902956; c=relaxed/simple;
	bh=W1kwXkRekICOQ5it7DjGjc4cUrwsMYnhCD5N+n11Y10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsKPi/O+ddrSHfqNtk/+zhlX47te69PUBZlFx2G+C5TjUScrxaLOyvWVXsoZGs2ghY//1yNI+uYi3y/lMZcBtkPPre13h3LkLfhvIW8C5S48Xg5M+MS9K5ea06FKGScAl7maiBIlrsk4ZtHK3RhNqR4tnXanRoc8aVwqTjLipig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsTeQnia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsTeQnia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C9DC2BCB8;
	Mon,  4 May 2026 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902955;
	bh=W1kwXkRekICOQ5it7DjGjc4cUrwsMYnhCD5N+n11Y10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsTeQniagTGxduGdDYK6dYNakqFyKgQe4t75BmkRZN9S/TPIcxMzX4EZsCNf/EM/c
	 Xg0i18Oh+//GoeqbNGa5LfYzCiPucV1kHLNQdPdqRTx+foXu/pBCTQTdV+pJ2IJrKC
	 wDaSC5LlDTpgUwaTCCtw9PEvCj/WQajDovzUvPas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.0 047/307] of: unittest: fix use-after-free in of_unittest_changeset()
Date: Mon,  4 May 2026 15:48:52 +0200
Message-ID: <20260504135144.603303099@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


