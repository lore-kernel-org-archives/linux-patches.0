Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA9912FB31;
	Wed, 19 Jun 2024 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802591; cv=none; b=mfFO7R3Al+90gWR5BCyj+a2GdmZ/j5i6LLX9VemLbv1KPRkw09WHc/5XjGGRYMShFlZFbFPmyggMHeEMKEDi1iT7ei1InKiPpG3MOxk0TeFe7Oip42nlkJptzj6dR5Nxx1etFacIHwDgLtxmGliqIvm8UkJZPC7NHzFcYGLzdqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802591; c=relaxed/simple;
	bh=8si5d2mMd8i1CbQsoOqpiygMLDXB/Ioj4/pxq9S0bhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4mBN+vUn2zbp+Ir2bn5p7n85CKQ8Ruf+OSF4Tgc8hszhNZcc07b1LCTGakINLLUgHNJ3mhzq/glgUVK9Kj9UzwV0cAqh+pqNoBR4bQnm1j8ZZ+hh6oG1dYt7Fa+WFiiXM4ZVJ6NwgRRbweRbMKMejBRmM1e5OLK6oqM+n10jR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mg/WwsD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mg/WwsD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63B6C2BBFC;
	Wed, 19 Jun 2024 13:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802591;
	bh=8si5d2mMd8i1CbQsoOqpiygMLDXB/Ioj4/pxq9S0bhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mg/WwsD3cuzCkcK052MU5pRaACAJ+AfzIeaoJ1o49QV3MQnlrN1kn7yOmC4P3Izge
	 KVU5vNBXjvTr4Z6qip1nh3F+TPXQJAjO9lDQGTUbPvZFtV2dDnQC71d9z+jdBKVP09
	 Mtv9dt6TfJKDiQWWClzLgLSofancsdYUZFoO1fzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH 6.6 247/267] selftests/net: add variable NS_LIST for lib.sh
Date: Wed, 19 Jun 2024 14:56:38 +0200
Message-ID: <20240619125615.801428914@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

commit b6925b4ed57cccf42ca0fb46c7446f0859e7ad4b upstream.

Add a global variable NS_LIST to store all the namespaces that setup_ns
created, so the caller could call cleanup_all_ns() instead of remember
all the netns names when using cleanup_ns().

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20231213060856.4030084-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/lib.sh |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -6,6 +6,8 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+# namespace list created by setup_ns
+NS_LIST=""
 
 ##############################################################################
 # Helpers
@@ -56,6 +58,11 @@ cleanup_ns()
 	return $ret
 }
 
+cleanup_all_ns()
+{
+	cleanup_ns $NS_LIST
+}
+
 # setup netns with given names as prefix. e.g
 # setup_ns local remote
 setup_ns()
@@ -82,4 +89,5 @@ setup_ns()
 		ip -n "$ns" link set lo up
 		ns_list="$ns_list $ns"
 	done
+	NS_LIST="$NS_LIST $ns_list"
 }


