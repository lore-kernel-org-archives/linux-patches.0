Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09802E6D23;
	Tue, 15 Jul 2025 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585854; cv=none; b=beg7aEzOTZ0bGK9KrUsrnwomeqwihdUT3oYHC8ds4e5tEE0jP6g2gPVS1U+nd5UXIkyd1q3r99CXjuyaMhCDEuP3F1bBSNnpUkFObTEEs97ZGyJDgOuT+jE/C7xiFC4yuaRN/ry8zcWtbzsMi7ppgvGTPsdemcEGsp3NWRnFNJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585854; c=relaxed/simple;
	bh=pGCBf+TtzAXRxe0ki5jKYZUkvHjpZ3LLsil4GrXuTmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTj6VvqD+d+1mwL0T8z9hkU6CG4YOuv/QBQXLjGyqpNVwEHs54qPte4sCeJgY+Hvke3bkgMrcwmAqN9AcWBsHsncCAeyLL6bs83JeH+0XUT7hLouGuI88UjO6hJGxhstk2/sXJNgSr5Fp467/WqcBw9QP034RB92yWG1K8xU9+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wwi7fGTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wwi7fGTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D848CC4CEFD;
	Tue, 15 Jul 2025 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585854;
	bh=pGCBf+TtzAXRxe0ki5jKYZUkvHjpZ3LLsil4GrXuTmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wwi7fGTSVAa/AeZDwKcMHepuhzW5sRI4k4sU0Is4P39VA4Nv1e9cbosCe1gySxvYH
	 hu9VlgVyjcVrdxHqc53JMS+wZuLlAY1ityB9dRNyIvqfz7Z0VD3c9WJ/M7rH3Bwuji
	 3Zk+lcnzW6oXu89jHmk1pRADRa6iS9ExELhpls4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Corey Minyard <corey@minyard.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: [PATCH 6.6 032/109] ipmi:msghandler: Fix potential memory corruption in ipmi_create_user()
Date: Tue, 15 Jul 2025 15:12:48 +0200
Message-ID: <20250715130800.169958034@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit fa332f5dc6fc662ad7d3200048772c96b861cf6b upstream.

The "intf" list iterator is an invalid pointer if the correct
"intf->intf_num" is not found.  Calling atomic_dec(&intf->nr_users) on
and invalid pointer will lead to memory corruption.

We don't really need to call atomic_dec() if we haven't called
atomic_add_return() so update the if (intf->in_shutdown) path as well.

Fixes: 8e76741c3d8b ("ipmi: Add a limit on the number of users that may use IPMI")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-ID: <aBjMZ8RYrOt6NOgi@stanley.mountain>
Signed-off-by: Corey Minyard <corey@minyard.net>
[ - Dropped change to the `if (intf->in_shutdown)` block since that logic
    doesn't exist yet.
  - Modified out_unlock to release the srcu lock instead of the mutex
    since we don't have the mutex here yet. ]
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1241,7 +1241,7 @@ int ipmi_create_user(unsigned int
 	}
 	/* Not found, return an error */
 	rv = -EINVAL;
-	goto out_kfree;
+	goto out_unlock;
 
  found:
 	if (atomic_add_return(1, &intf->nr_users) > max_users) {
@@ -1283,6 +1283,7 @@ int ipmi_create_user(unsigned int
 
 out_kfree:
 	atomic_dec(&intf->nr_users);
+out_unlock:
 	srcu_read_unlock(&ipmi_interfaces_srcu, index);
 	vfree(new_user);
 	return rv;


