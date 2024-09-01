Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF2E14290C;
	Sun,  1 Sep 2024 16:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207915; cv=none; b=pqwLRrwDe3M43MQTzwmLILJ2kjDOdvWia2RjGfVtY4UUPB3Ht6daT7RozRvFDGTkBYOYh14cj4EuGni4wAnCfoJjSBtlgCRJj4XF0etZyUdl8HRcAZNyIkxPMlSwqWqFN0Tw149FoCdYm89qGCiCzUvs1mKRW331iWOfG2eUGjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207915; c=relaxed/simple;
	bh=qyRW9K0UhWuoAAKxwU3jj5PQDo2bYaEDrP2T0KHxjsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5gA1AiUzLzjvOSWUZA//kRxPwobqwRv3DamdHDV/Iwz3IqioZSUtw1KCcbKTOAvwZDjg7PSB9jU09cKaHdoEbjGS8r+zkN0Kc7M5NF0xxbECbGQ94U2jFuX3xZxb5T7Wz995hy3cL6LaBCd33t6rzMSGH0YlCcnfrzXD9ehX0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZJtNXE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZJtNXE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFA4C4CEC3;
	Sun,  1 Sep 2024 16:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207915;
	bh=qyRW9K0UhWuoAAKxwU3jj5PQDo2bYaEDrP2T0KHxjsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZJtNXE5jx6PfaYV5hxyK6s5BfLS2rjoJ1ph8+T/PYSXaa14r+bXt+ySGFZwPjl0o
	 EEmhvl1FQLZb8mtS6Ifu+cD680e6Tn2wuMhbTAlX+Dcn264UYsW8wKELDpPGKf0Ga8
	 ciFUseeu7luE1m8vdxKe6uPtZ5O4G+XDA/98jYnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 17/93] mptcp: pm: send ACK on an active subflow
Date: Sun,  1 Sep 2024 18:16:04 +0200
Message-ID: <20240901160808.010347510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit c07cc3ed895f9bfe0c53b5ed6be710c133b4271c upstream.

Taking the first one on the list doesn't work in some cases, e.g. if the
initial subflow is being removed. Pick another one instead of not
sending anything.

Fixes: 84dfe3677a6f ("mptcp: send out dedicated ADD_ADDR packet")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -776,9 +776,12 @@ void mptcp_pm_nl_addr_send_ack(struct mp
 	    !mptcp_pm_should_rm_signal(msk))
 		return;
 
-	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
-	if (subflow)
-		mptcp_pm_send_ack(msk, subflow, false, false);
+	mptcp_for_each_subflow(msk, subflow) {
+		if (__mptcp_subflow_active(subflow)) {
+			mptcp_pm_send_ack(msk, subflow, false, false);
+			break;
+		}
+	}
 }
 
 int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,


