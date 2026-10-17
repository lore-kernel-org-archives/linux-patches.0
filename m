Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7CF3BF699;
	Sat, 17 Oct 2026 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259668; cv=none; b=LHqTuZD+WmeBPRCXtWf2jabFNQrjYO/5rYVsypwZ92CoDcxLwc7tCtI13QwmcDrX83oYnV4jCJ1xgsHJfBmaw54VELlhiCGmUIGRiRtX3qfuHn9C/y4Dy2WSy6j09Ma0UrG/jNzAiQfFohVxXvZcDPvquTD6U2ZMuJCBOQfEcF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259668; c=relaxed/simple;
	bh=StaTtuvodAeXtAQaj5mlSoyV1tf4BRLHFRkFLO4SbUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R21vcUWG31X/Td1dAyaEgBtOat8r0dyBniwyHXoEzsPJxz0ldGQxan5iiWLeVgpUBuxr5zfVMN0XZFJxu5fQeY2InJbgedwIRSDj4RO2iaaY5U9GCOkzf+eAI6TI6WfPC+wkwYFhgspRvNAh4pOdzB91ftjAs8hCYOOWbwTvUjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnqLgdM+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnqLgdM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D0A1F000C4;
	Sat, 17 Oct 2026 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259667;
	bh=1jaYCh4QNzM/t4BMQ2qK49vuLxYDRQzaKrGM5elYqL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnqLgdM+1z1jIUt6brTtjiF4yeTseYPGCqnxfQKU+6N0zZfWhg5XQfGgThgzcL3yB
	 kgGAiypom10EU3mqmGlIN32EmsEQKEhS/vvYe9FBqwU4GOM7F0PXkFWIvoN0Pvun8F
	 riasxtbVqbnqb27FGWXfXOdv2O8Q6Wt9DRPlHx9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1291/1674] SUNRPC: Add a server-side API for retrieving an RPCs pseudoflavor
Date: Sat, 17 Oct 2026 17:59:23 +0200
Message-ID: <20261017160504.278140286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit deb704281f076097b0347116a82edeba96697db1 ]

NFSD will use this new API to determine whether nfsd_splice_read is
safe to use. This avoids the need to add a dependency to NFSD for
CONFIG_SUNRPC_GSS.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: c479bde671cb ("sunrpc: defer rq_argp and rq_resp free until after RCU grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svcauth.h    |  7 ++++++-
 net/sunrpc/auth_gss/svcauth_gss.c |  6 ++++++
 net/sunrpc/svcauth.c              | 16 ++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/svcauth.h b/include/linux/sunrpc/svcauth.h
index 6f90203edbf8d..61c455f1e1f50 100644
--- a/include/linux/sunrpc/svcauth.h
+++ b/include/linux/sunrpc/svcauth.h
@@ -131,8 +131,11 @@ enum svc_auth_status {
  *   This call releases a domain.
  *
  * set_client()
- *   Givens a pending request (struct svc_rqst), finds and assigns
+ *   Given a pending request (struct svc_rqst), finds and assigns
  *   an appropriate 'auth_domain' as the client.
+ *
+ * pseudoflavor()
+ *   Returns RPC_AUTH pseudoflavor in use by @rqstp.
  */
 struct auth_ops {
 	char *	name;
@@ -143,11 +146,13 @@ struct auth_ops {
 	int			(*release)(struct svc_rqst *rqstp);
 	void			(*domain_release)(struct auth_domain *dom);
 	enum svc_auth_status	(*set_client)(struct svc_rqst *rqstp);
+	rpc_authflavor_t	(*pseudoflavor)(struct svc_rqst *rqstp);
 };
 
 struct svc_xprt;
 
 extern enum svc_auth_status svc_authenticate(struct svc_rqst *rqstp);
+extern rpc_authflavor_t svc_auth_flavor(struct svc_rqst *rqstp);
 extern int	svc_authorise(struct svc_rqst *rqstp);
 extern enum svc_auth_status svc_set_client(struct svc_rqst *rqstp);
 extern int	svc_auth_register(rpc_authflavor_t flavor, struct auth_ops *aops);
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 01a1583434636..666a53c857765 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -2015,6 +2015,11 @@ svcauth_gss_domain_release(struct auth_domain *dom)
 	call_rcu(&dom->rcu_head, svcauth_gss_domain_release_rcu);
 }
 
+static rpc_authflavor_t svcauth_gss_pseudoflavor(struct svc_rqst *rqstp)
+{
+	return svcauth_gss_flavor(rqstp->rq_gssclient);
+}
+
 static struct auth_ops svcauthops_gss = {
 	.name		= "rpcsec_gss",
 	.owner		= THIS_MODULE,
@@ -2023,6 +2028,7 @@ static struct auth_ops svcauthops_gss = {
 	.release	= svcauth_gss_release,
 	.domain_release = svcauth_gss_domain_release,
 	.set_client	= svcauth_gss_set_client,
+	.pseudoflavor	= svcauth_gss_pseudoflavor,
 };
 
 static int rsi_cache_create_net(struct net *net)
diff --git a/net/sunrpc/svcauth.c b/net/sunrpc/svcauth.c
index aa4429d0b8106..1619211f0960a 100644
--- a/net/sunrpc/svcauth.c
+++ b/net/sunrpc/svcauth.c
@@ -160,6 +160,22 @@ svc_auth_unregister(rpc_authflavor_t flavor)
 }
 EXPORT_SYMBOL_GPL(svc_auth_unregister);
 
+/**
+ * svc_auth_flavor - return RPC transaction's RPC_AUTH flavor
+ * @rqstp: RPC transaction context
+ *
+ * Returns an RPC flavor or GSS pseudoflavor.
+ */
+rpc_authflavor_t svc_auth_flavor(struct svc_rqst *rqstp)
+{
+	struct auth_ops *aops = rqstp->rq_authop;
+
+	if (!aops->pseudoflavor)
+		return aops->flavour;
+	return aops->pseudoflavor(rqstp);
+}
+EXPORT_SYMBOL_GPL(svc_auth_flavor);
+
 /**************************************************
  * 'auth_domains' are stored in a hash table indexed by name.
  * When the last reference to an 'auth_domain' is dropped,
-- 
2.53.0



