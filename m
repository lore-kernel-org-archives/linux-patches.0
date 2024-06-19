Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9A112FB31;
	Wed, 19 Jun 2024 13:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802624; cv=none; b=PmtREWru4uJkUHBnnZ0f7JqtA+I4GTFTiaR2gcEQZ66qgqJfDmgcpzoFPmFeJ91c/IWibSI4QXQqPn09D/HDVWsfnvgnjb+m8mqhUnjoYZB1mdSmuQTbF7GCCbiyNYw9N16mhqt3oTxtYnEr/gTqS3R9yW9QrD4uzW4DCna4IuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802624; c=relaxed/simple;
	bh=A9ZSSzQeoWGeD+Mkb2ugQIllSkzmhVMG6z1VzBebIBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFxrD+lKIKensy6PPwbD9qGqmgHbj56xovOiQ0TuLw7r3KhTLT/B3/Wnegu8AnhkTDuvp5cIP1FHrLytXP6Ixm/4tr70GaIS0RKsxechCzD/nEHFyT7O1yP5qlmJqomE+iVaZ/TeD4sYWlsOmvxNPnpG0ZyYxdYhcWpAHteyfj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ef6TsGDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ef6TsGDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61838C2BBFC;
	Wed, 19 Jun 2024 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802623;
	bh=A9ZSSzQeoWGeD+Mkb2ugQIllSkzmhVMG6z1VzBebIBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ef6TsGDmMcR7fNShK67q2zZjnB1+wt8ehE95RhPi3PFQMJzd68ugLbqsxtyYGlA8/
	 S4Ii7vsTgtvvGATvjvzCaJDR50z+aXGkfry3aQl4dcflpeIHPEkF34WdwiJXLsmUDZ
	 7ZwmLD9sxqCTvTFxDNYY7FUCmZXFLjKKuuB26HLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 252/267] selftests/net/lib: no need to record ns name if it already exist
Date: Wed, 19 Jun 2024 14:56:43 +0200
Message-ID: <20240619125615.990867845@linuxfoundation.org>
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

commit 83e93942796db58652288f0391ac00072401816f upstream.

There is no need to add the name to ns_list again if the netns already
recoreded.

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/lib.sh |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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


