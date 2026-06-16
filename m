Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AD13CE4BA;
	Tue, 16 Jun 2026 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632958; cv=none; b=oTpobq+l3KO94bKjUP1fsuqfazZ1LfhDZceaTjN8KU23nAsLROJYfrEXaRkhWbUscyM2J4iuHowCxoW7X2WhrllXPvJQUG6a+Ovf2sHw3rIg0FmGv9pLfv4mHkPR2n0J1JdRysA2/hr4+S1ettfr+BnVLBq7eS3xA1ip6lkQwCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632958; c=relaxed/simple;
	bh=/+yPKQ6wWVaQJN4laaBSoUkVY154Gxd8/cjhH5S0pqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ks+9hXAZKdRvK56zJMdhCoUPwDqvTLje9KXWkpCAaMBiq08q5/Hj0ie8EWViybOq44S4ENirIQIaZipoBDaAUc2X26D+le2nfT2yem5h43irK++Ir7fUuS47DagH3AZei7XX1BZ3/0TmO4WPocuk4JD4O8LRqWYwHHRuypWeuLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9PquIFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9PquIFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B241F000E9;
	Tue, 16 Jun 2026 18:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632957;
	bh=jnvROPG9x/gO8hB214Sejs161+3rEth5EsSfkClrAts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9PquIFGprUXqPHWTCNRiNRC4j3IYB2zF64Aknx39IDs0DERxZ+UTdBqYG6stM+kK
	 xzjUEtLbRGi2H79NAemP3gvoquazk1MXedm/plERMbAvh9lj+JwY8w3XzLBYBMuE1X
	 aLi0lni/W7JJ9hhVfztnq5pKSbksJ211Jou6t2mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.1 508/522] ipmi:ssif: NULL thread on error
Date: Tue, 16 Jun 2026 20:30:55 +0530
Message-ID: <20260616145149.512852593@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit a8aebe93a4938c0ca1941eeaae821738f869be3d upstream.

Cleanup code was checking the thread for NULL, but it was possibly
a PTR_ERR() in one spot.

Spotted with static analysis.

Link: https://sourceforge.net/p/openipmi/mailman/message/59324676/
Fixes: 75c486cb1bca ("ipmi:ssif: Clean up kthread on errors")
Cc: <stable@vger.kernel.org> # 91eb7ec72612: ipmi:ssif: Remove unnecessary indention
Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1886,6 +1886,7 @@ static int ssif_probe(struct i2c_client
 					"kssif%4.4x", thread_num);
 	if (IS_ERR(ssif_info->thread)) {
 		rv = PTR_ERR(ssif_info->thread);
+		ssif_info->thread = NULL;
 		dev_notice(&ssif_info->client->dev,
 			   "Could not start kernel thread: error %d\n",
 			   rv);


