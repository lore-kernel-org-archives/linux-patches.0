Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667E62E337B;
	Tue, 15 Jul 2025 13:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587227; cv=none; b=XQWohx5IIyLt3M5nVqq5YWP8LwbDVgCYsH/KjGVVOHjwaFRbd3GIhnXJDm9XwdTZtW4IXW6g+XW+SgWWuAqf6vcOenctO2tz3b76D6L6cJ2yoGX4K+LySPTt2EVJkYuTM3XFIQOFNAl+ohPySqwEbYxWAOYNee6Q8gbr5DIXCXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587227; c=relaxed/simple;
	bh=XvoVb+oNm2iWh93ScbduYY7mvcy9OkmRTY/hbPDkif8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAj6L9ZL0O0Idxm0WPCOFdRvAFxIYnYmanjC/8eLBq8RO0BvEBcJpQuVsHQ+LB6GsOSDAeOT0gR05+fq2QZpz6JGWSlcI7E9Xj8mt7AO/SI33G304QZ2WiYfT1ldxHtSZfPhUnRiCR63NII9UsHaHsiH5ebKricyLES0PS5kBJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V11XtMZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V11XtMZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F09C4CEF7;
	Tue, 15 Jul 2025 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587226;
	bh=XvoVb+oNm2iWh93ScbduYY7mvcy9OkmRTY/hbPDkif8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V11XtMZ6RnFxf5VR9p/L1+hLVCXqjGCn8laUNduaUD+3lhoTKntmwa/sVt/Z7NYYV
	 KEHO1qNrmJDh6krMrM8dG5HnnSixhsOFITZfq+O/MIr33OYy2gO1B424gvTF8klvym
	 o/2d6cjCoyArcwwFI1Im4rcOSYhnSOSWr8IEUzJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Corey Minyard <corey@minyard.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: [PATCH 6.1 22/88] ipmi:msghandler: Fix potential memory corruption in ipmi_create_user()
Date: Tue, 15 Jul 2025 15:13:58 +0200
Message-ID: <20250715130755.405588993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


