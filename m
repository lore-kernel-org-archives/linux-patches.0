Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6781183CC8;
	Thu,  5 Sep 2024 10:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530400; cv=none; b=UHvrSxInsnIkg704S7uChazzKpfw8ye3jzgR13lHXEwcaFccrVvOFb4gOrPPducU4IYswTnTK+JKAPiTJGbsOH/JLzoOmPyb1c3mQlgIOyRDrjanw8SY2ES3OVFBdNhtpwQ9ZJ6lm36dRBjMkXIXqZ7k454aAtVQPhAEYxvq5Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530400; c=relaxed/simple;
	bh=owUAyoT/Z/njindrUh6o2a9kY1QWXRVa/DWtUS15zYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyQZpAvoxo6/mKyA4gpAvCq5uyMTOXaZD9B1f6f7Bs6HPFYSdW4k4ri36GAYx+qG+k39qZzLL1ejOfnOufX18qGK359PTMqOeVfwNGcoQ3YuAetChnsKk3JkLmRGpZ+62lAimwhucQjPpUEQeoQpt7JTB6ZmqA9EyVHWAuhiEbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNieWSZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNieWSZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C35C4CEC3;
	Thu,  5 Sep 2024 09:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530400;
	bh=owUAyoT/Z/njindrUh6o2a9kY1QWXRVa/DWtUS15zYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNieWSZarfL/iGVH/QNz+60PCoM/v6WzLc5nt9vhKzEwpf52oj1KRimTipMLAA/n1
	 NxJWRs6cKyJfpTY7du7vqki/HDOKULRactZEgTqlCB3TqhlsbtQJHQBKCt4s8uOdIR
	 A1VQY+mvSTlY8/2HLjNoLEzi349vJdzUdmM3XmFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 013/101] mptcp: pm: fullmesh: select the right ID later
Date: Thu,  5 Sep 2024 11:40:45 +0200
Message-ID: <20240905093716.612811424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 09355f7abb9fbfc1a240be029837921ea417bf4f upstream.

When reacting upon the reception of an ADD_ADDR, the in-kernel PM first
looks for fullmesh endpoints. If there are some, it will pick them,
using their entry ID.

It should set the ID 0 when using the endpoint corresponding to the
initial subflow, it is a special case imposed by the MPTCP specs.

Note that msk->mpc_endpoint_id might not be set when receiving the first
ADD_ADDR from the server. So better to compare the addresses.

Fixes: 1a0d6136c5f0 ("mptcp: local addresses fullmesh")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-12-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in pm_netlink.c, because the new 'mpc_addr' variable is
  added where the 'local' one was, before commit b9d69db87fb7 ("mptcp:
  let the in-kernel PM use mixed IPv4 and IPv6 addresses"), that is not
  a candidate for the backports. This 'local' variable has been moved to
  the new place to reduce the scope, and help with possible future
  backports. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -648,7 +648,7 @@ static unsigned int fill_local_addresses
 {
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_pm_addr_entry *entry;
-	struct mptcp_addr_info local;
+	struct mptcp_addr_info mpc_addr;
 	struct pm_nl_pernet *pernet;
 	unsigned int subflows_max;
 	int i = 0;
@@ -656,6 +656,8 @@ static unsigned int fill_local_addresses
 	pernet = pm_nl_get_pernet_from_msk(msk);
 	subflows_max = mptcp_pm_get_subflows_max(msk);
 
+	mptcp_local_address((struct sock_common *)msk, &mpc_addr);
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
@@ -673,7 +675,13 @@ static unsigned int fill_local_addresses
 
 		if (msk->pm.subflows < subflows_max) {
 			msk->pm.subflows++;
-			addrs[i++] = entry->addr;
+			addrs[i] = entry->addr;
+
+			/* Special case for ID0: set the correct ID */
+			if (mptcp_addresses_equal(&entry->addr, &mpc_addr, entry->addr.port))
+				addrs[i].id = 0;
+
+			i++;
 		}
 	}
 	rcu_read_unlock();
@@ -682,6 +690,8 @@ static unsigned int fill_local_addresses
 	 * 'IPADDRANY' local address
 	 */
 	if (!i) {
+		struct mptcp_addr_info local;
+
 		memset(&local, 0, sizeof(local));
 		local.family = msk->pm.remote.family;
 


