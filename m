Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F6861FDF;
	Mon, 27 May 2024 19:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838663; cv=none; b=e6IrQUEDdvU7i/LAHWFF9JOnu0pd52YAXo/p1vfPfew0sTbAKVKj3ARHwiMyeH0BAwwnFI7LVhnzNiDDsDJf3nVjTyYUdVnRTCMcNZ4h3jo/DGtJrdQ13qw8RT28KykYQM12TcFdlEWpa3bTUbJpxOUshJFdth5+Cbmp+aNxF0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838663; c=relaxed/simple;
	bh=feOZxWnIFR0C03bRXuI4jH6oATwhdS4tZz3RUKN+L9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfIu1aR/ONJKcXwVo0iC7Misn9UXvzvQGm2CNkIRCt3aF/EUydBfnIHH2PFWbcxRAyGrUOi2XE2kPjfKrMBhcGS9Pn3ohnEalCe4RDde4Q9xnsX4RerJe3HIhHQVTJO/yE/DppB34UuG5qW/xny2H9o0FJ9bvEzDUqLyrJssnY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FL6oFnAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FL6oFnAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F485C2BBFC;
	Mon, 27 May 2024 19:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838663;
	bh=feOZxWnIFR0C03bRXuI4jH6oATwhdS4tZz3RUKN+L9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FL6oFnAWIfKhJ0eSkhTj6v4dWcwG7Uat79kDj+56/6mEvJsBftoHO3GMP1PE9kRUr
	 yaP8P1qTEe/NKn1C4EHxnobIVoCMiHrYvcQIsyGUEosKXD6mD0X2RbHLcY9xGgeSyr
	 ntg311WOD3Mr4/mj8FnGdlYSPzMGBAObPGmz1rLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 478/493] selftests/net/lib: no need to record ns name if it already exist
Date: Mon, 27 May 2024 20:58:00 +0200
Message-ID: <20240527185645.781488742@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 83e93942796db58652288f0391ac00072401816f ]

There is no need to add the name to ns_list again if the netns already
recoreded.

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index f9fe182dfbd44..56a9454b7ba35 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -73,15 +73,17 @@ setup_ns()
 	local ns=""
 	local ns_name=""
 	local ns_list=""
+	local ns_exist=
 	for ns_name in "$@"; do
 		# Some test may setup/remove same netns multi times
 		if unset ${ns_name} 2> /dev/null; then
 			ns="${ns_name,,}-$(mktemp -u XXXXXX)"
 			eval readonly ${ns_name}="$ns"
+			ns_exist=false
 		else
 			eval ns='$'${ns_name}
 			cleanup_ns "$ns"
-
+			ns_exist=true
 		fi
 
 		if ! ip netns add "$ns"; then
@@ -90,7 +92,7 @@ setup_ns()
 			return $ksft_skip
 		fi
 		ip -n "$ns" link set lo up
-		ns_list="$ns_list $ns"
+		! $ns_exist && ns_list="$ns_list $ns"
 	done
 	NS_LIST="$NS_LIST $ns_list"
 }
-- 
2.43.0



