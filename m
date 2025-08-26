Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03AA35334B;
	Tue, 26 Aug 2025 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216827; cv=none; b=heOMuKkqZfkoTbiJDTl4sZIK9UxvRM6kh/hBdd7aI2jcdoUDMAhQzRK2ThlIizWphUp5sJmwOdBJrzyYa8NjdyMrBLWt7dWoNjt9DjS/h5t5aWrcpB1vW+TadgZUCyoX/Y0fqAl4LAhtiom82HMvg6iO9xM6FI/f5GgneFshww4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216827; c=relaxed/simple;
	bh=Tzhwc9RoU9BQOkfPT3c8TgWHKZVzpDLasqXU3unAkgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcpfCqejVxbfEVbXncklgIwwCXG4F6V969HsKj0/oW8UHikLbGDF6riNtQKl/pPjt5z1YlV9Wd3eBLiYZsGVg2FCO0pxvGxOcbYuwlQAHIpH0d2+gDm+/wl9Zs4WJPAu8M/HVh/OJx6lUD6BpVEWOBr+imSA+JN9VNdl9ysa/KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dH5MH8W6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dH5MH8W6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DECC4CEF1;
	Tue, 26 Aug 2025 14:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216826;
	bh=Tzhwc9RoU9BQOkfPT3c8TgWHKZVzpDLasqXU3unAkgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dH5MH8W6F/CO9/0fwtaXov2BmCTo4ScPqQPxhcgk/oxzXNkWPB9zmYwuGTNSiLmW4
	 d/mMm+Y2wnW+SB5gV0le5muWpCKNrTGz76ZjrRS/4wrmJed9YWgGUlcGQMV+qGuIHZ
	 jjjMK1JzX0TVPRG6YwWMwAeti2qcNO19+AT9EiJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 557/644] mptcp: introduce MAPPING_BAD_CSUM
Date: Tue, 26 Aug 2025 13:10:48 +0200
Message-ID: <20250826111000.331989303@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 31bf11de146c3f8892093ff39f8f9b3069d6a852 upstream.

This allow moving a couple of conditional out of the fast path,
making the code more easy to follow and will simplify the next
patch.

Fixes: ae66fb2ba6c3 ("mptcp: Do TCP fallback on early DSS checksum failure")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in subflow.c, because commit 0348c690ed37 ("mptcp: add the
  fallback check") is not in this version. This commit is linked to a
  new feature, changing the context around. The new condition can still
  be added at the same place. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -848,7 +848,8 @@ enum mapping_status {
 	MAPPING_INVALID,
 	MAPPING_EMPTY,
 	MAPPING_DATA_FIN,
-	MAPPING_DUMMY
+	MAPPING_DUMMY,
+	MAPPING_BAD_CSUM
 };
 
 static void dbg_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
@@ -963,9 +964,7 @@ static enum mapping_status validate_data
 				 subflow->map_data_csum);
 	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
-		if (subflow->mp_join || subflow->valid_csum_seen)
-			subflow->send_mp_fail = 1;
-		return subflow->mp_join ? MAPPING_INVALID : MAPPING_DUMMY;
+		return MAPPING_BAD_CSUM;
 	}
 
 	subflow->valid_csum_seen = 1;
@@ -1188,10 +1187,8 @@ static bool subflow_check_data_avail(str
 
 		status = get_mapping_status(ssk, msk);
 		trace_subflow_check_data_avail(status, skb_peek(&ssk->sk_receive_queue));
-		if (unlikely(status == MAPPING_INVALID))
-			goto fallback;
-
-		if (unlikely(status == MAPPING_DUMMY))
+		if (unlikely(status == MAPPING_INVALID || status == MAPPING_DUMMY ||
+			     status == MAPPING_BAD_CSUM))
 			goto fallback;
 
 		if (status != MAPPING_OK)
@@ -1232,7 +1229,10 @@ no_data:
 
 fallback:
 	/* RFC 8684 section 3.7. */
-	if (subflow->send_mp_fail) {
+	if (status == MAPPING_BAD_CSUM &&
+	    (subflow->mp_join || subflow->valid_csum_seen)) {
+		subflow->send_mp_fail = 1;
+
 		if (mptcp_has_another_subflow(ssk) ||
 		    !READ_ONCE(msk->allow_infinite_fallback)) {
 			while ((skb = skb_peek(&ssk->sk_receive_queue)))


