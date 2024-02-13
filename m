Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59875F54E;
	Tue, 13 Feb 2024 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845350; cv=none; b=csp/DGjllLQ2XgN9DCvWUzRzyv60jqTnnIRZYCwIDQXnwY1K7qcRVSCzlK+4Fau1pgnBVSVKK+qvcK+OO3R0F1Jsvc4+dpnoHp8WmqSotSQvBpFbQfs8yi946Aap63BL6CdSgvFNShOmyL7s6yxuGyjfTQUL8UQ/slWD2SPx6Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845350; c=relaxed/simple;
	bh=yyOnRfagP7PeA8BSp751pAXqrlR28ocGEvpaHSEOU0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIg6MBlnvv1L6/53VX44cilYDRf9Mmjhh76JrRm6l5E9LL21HlFMyyUZCTZ0zaYduJFXOJ3wnCMYN/IffalCB/UsjRiiHFIwb6Mdc8SkEyxmmOkBcFSRaXcrL/GwIUX7BBKGZTkJWpUSUz5CWfBbILyhlLtAvOvH6lePyHx9VZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPAdZLaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPAdZLaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DDCC433F1;
	Tue, 13 Feb 2024 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845350;
	bh=yyOnRfagP7PeA8BSp751pAXqrlR28ocGEvpaHSEOU0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPAdZLaUN5SjVUBUR6MUKVpzYBZFtGElosAZtEeGvNRU7YOFeXPKjK1OYgo4LgCfp
	 h4tTCR6RJ3uyBVvpqD8SmAHL6FotfjAYp0RNwCg31+AJT6Bb0sxnCCMcOzUjdE5nMO
	 AWogV+fDeMbQH8sXzcl2RZaWkagPRCaNq+iLNfIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/121] selftests: net: fix tcp listener handling in pmtu.sh
Date: Tue, 13 Feb 2024 18:21:03 +0100
Message-ID: <20240213171854.574030453@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit e71e016ad0f6e641a7898b8cda5f62f8e2beb2f1 ]

The pmtu.sh test uses a few TCP listener in a problematic way:
It hard-codes a constant timeout to wait for the listener starting-up
in background. That introduces unneeded latency and on very slow and
busy host it can fail.

Additionally the test starts again the same listener in the same
namespace on the same port, just after the previous connection
completed. Fast host can attempt starting the new server before the
old one really closed the socket.

Address the issues using the wait_local_port_listen helper and
explicitly waiting for the background listener process exit.

Fixes: 136a1b434bbb ("selftests: net: test vxlan pmtu exceptions with tcp")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/f8e8f6d44427d8c45e9f6a71ee1a321047452087.1706812005.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 3f118e3f1c66..f0febc19baae 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -199,6 +199,7 @@
 #	Same as above but with IPv6
 
 source lib.sh
+source net_helper.sh
 
 PAUSE_ON_FAIL=no
 VERBOSE=0
@@ -1336,13 +1337,15 @@ test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception() {
 			TCPDST="TCP:[${dst}]:50000"
 		fi
 		${ns_b} socat -T 3 -u -6 TCP-LISTEN:50000 STDOUT > $tmpoutfile &
+		local socat_pid=$!
 
-		sleep 1
+		wait_local_port_listen ${NS_B} 50000 tcp
 
 		dd if=/dev/zero status=none bs=1M count=1 | ${target} socat -T 3 -u STDIN $TCPDST,connect-timeout=3
 
 		size=$(du -sb $tmpoutfile)
 		size=${size%%/tmp/*}
+		wait ${socat_pid}
 
 		[ $size -ne 1048576 ] && err "File size $size mismatches exepcted value in locally bridged vxlan test" && return 1
 	done
-- 
2.43.0



