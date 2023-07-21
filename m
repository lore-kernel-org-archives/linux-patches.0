Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1B127F1D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81CEC433C8;
	Fri, 21 Jul 2023 18:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965388;
	bh=2x0h1M7yJjUt9I8Q0Orf/aaFaD9NALueae8pLTBFBHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6ms9QW0jq1Z3RvxEW+yv7yoZ2BHu8h0ua7z2P/lM19FQKErfzyl4mlizDFcpD83P
	 JcUZpy0G+a0v1Yon3asdq/gA9K+fLTd0gc0MeCKF1fCw8KADXZeHctXnsDG1aP+b3p
	 QEDNjTi0GV5Vz7UUYtA0ByoODIOJhNvt/m8qgaxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 267/292] selftests: mptcp: pm_nl_ctl: fix 32-bit support
Date: Fri, 21 Jul 2023 18:06:16 +0200
Message-ID: <20230721160540.398787322@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 61d9658050260dbcbf9055479b7ac5bbbe1e8831 upstream.

When using pm_nl_ctl to validate userspace path-manager's behaviours, it
was failing on 32-bit architectures ~half of the time.

pm_nl_ctl was not reporting any error but the command was not doing what
it was expected to do. As a result, the expected linked event was not
triggered after and the test failed.

This is due to the fact the token given in argument to the application
was parsed as an integer with atoi(): in a 32-bit arch, if the number
was bigger than INT_MAX, 2147483647 was used instead.

This can simply be fixed by using strtoul() instead of atoi().

The errors have been seen "by chance" when manually looking at the
results from LKFT.

Fixes: 9a0b36509df0 ("selftests: mptcp: support MPTCP_PM_CMD_ANNOUNCE")
Cc: stable@vger.kernel.org
Fixes: ecd2a77d672f ("selftests: mptcp: support MPTCP_PM_CMD_REMOVE")
Fixes: cf8d0a6dfd64 ("selftests: mptcp: support MPTCP_PM_CMD_SUBFLOW_CREATE")
Fixes: 57cc361b8d38 ("selftests: mptcp: support MPTCP_PM_CMD_SUBFLOW_DESTROY")
Fixes: ca188a25d43f ("selftests: mptcp: userspace PM support for MP_PRIO signals")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -425,7 +425,7 @@ int dsf(int fd, int pm_family, int argc,
 	}
 
 	/* token */
-	token = atoi(params[4]);
+	token = strtoul(params[4], NULL, 10);
 	rta = (void *)(data + off);
 	rta->rta_type = MPTCP_PM_ATTR_TOKEN;
 	rta->rta_len = RTA_LENGTH(4);
@@ -551,7 +551,7 @@ int csf(int fd, int pm_family, int argc,
 	}
 
 	/* token */
-	token = atoi(params[4]);
+	token = strtoul(params[4], NULL, 10);
 	rta = (void *)(data + off);
 	rta->rta_type = MPTCP_PM_ATTR_TOKEN;
 	rta->rta_len = RTA_LENGTH(4);
@@ -598,7 +598,7 @@ int remove_addr(int fd, int pm_family, i
 			if (++arg >= argc)
 				error(1, 0, " missing token value");
 
-			token = atoi(argv[arg]);
+			token = strtoul(argv[arg], NULL, 10);
 			rta = (void *)(data + off);
 			rta->rta_type = MPTCP_PM_ATTR_TOKEN;
 			rta->rta_len = RTA_LENGTH(4);
@@ -710,7 +710,7 @@ int announce_addr(int fd, int pm_family,
 			if (++arg >= argc)
 				error(1, 0, " missing token value");
 
-			token = atoi(argv[arg]);
+			token = strtoul(argv[arg], NULL, 10);
 		} else
 			error(1, 0, "unknown keyword %s", argv[arg]);
 	}
@@ -1347,7 +1347,7 @@ int set_flags(int fd, int pm_family, int
 				error(1, 0, " missing token value");
 
 			/* token */
-			token = atoi(argv[arg]);
+			token = strtoul(argv[arg], NULL, 10);
 		} else if (!strcmp(argv[arg], "flags")) {
 			char *tok, *str;
 


