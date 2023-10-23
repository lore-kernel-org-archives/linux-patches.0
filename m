Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD7814F6A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlcwvwhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4667FC433C8;
	Mon, 23 Oct 2023 11:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060124;
	bh=H3KqdsuM1+ZogLizeq/44eRGlEDxV5hcHcQATf7wGiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlcwvwhl4t9hJABO24gEWKQj5I4R/3DRjdV3VKl+S+vgX4yCfMwezLjeH6xIOTYSr
	 0XWdqlu9OJTiuYA3Z4BeEnTKWw3p9bjsklrIX+zvJmsSIqSsVjrUFX2B4+DBKt6RHy
	 TEBrXWcU4z3H9LdwTdeetehocpQv5mKvRgyRA+sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 067/196] selftests: netfilter: Run nft_audit.sh in its own netns
Date: Mon, 23 Oct 2023 12:55:32 +0200
Message-ID: <20231023104830.439100097@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

commit 2e2d9c7d4d37d74873583d7b0c94eac8b6869486 upstream.

Don't mess with the host's firewall ruleset. Since audit logging is not
per-netns, add an initial delay of a second so other selftests' netns
cleanups have a chance to finish.

Fixes: e8dbde59ca3f ("selftests: netfilter: Test nf_tables audit logging")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/netfilter/nft_audit.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
index e94a80859bbd..99ed5bd6e840 100755
--- a/tools/testing/selftests/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -11,6 +11,12 @@ nft --version >/dev/null 2>&1 || {
 	exit $SKIP_RC
 }
 
+# Run everything in a separate network namespace
+[ "${1}" != "run" ] && { unshare -n "${0}" run; exit $?; }
+
+# give other scripts a chance to finish - audit_logread sees all activity
+sleep 1
+
 logfile=$(mktemp)
 rulefile=$(mktemp)
 echo "logging into $logfile"
-- 
2.42.0



