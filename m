Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC8F1E525;
	Mon,  1 Apr 2024 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990107; cv=none; b=Zm+vsiWM1XfbtmqFNSw8aVnWP3wamZEYAUuoZmhks93+ia7p5sICm9Gow9j3LVsG8fyydP42bWySsjEsLkNB8BgJkj8UavEiZmaKqIXIrg3TkAdE1bzcBGkIa1gPcJ3bqoNXCl70A7MjeDlQ8TcsDC4xBnh3pYh0hfTLH+zKQZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990107; c=relaxed/simple;
	bh=Vq6A99tFXabI7Q04SOTkDIz9tPtW4yo2wP6AorNqq3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByBvsZDq1dbt5+fjEVgoctQxe6C0dWG+5T7klsY6Kjvg0tpTdrxLvB6voPXU7uI96ZW0RR9GWd5K2JkzajFhFwd6CywghY/y5X8wwUGaeGIEsrnka5Cq0WP9FklJbTJhdh/32+ehBw5Fi45u0xxniheHY8YMkzlj6xfX9I4MU4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuXzYo1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuXzYo1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA589C433F1;
	Mon,  1 Apr 2024 16:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990107;
	bh=Vq6A99tFXabI7Q04SOTkDIz9tPtW4yo2wP6AorNqq3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuXzYo1v0zihTt3xnnhwRibWC59Lay1xzzaX+A3Tvh3cEIlGdxxmg7TUVbjmJQosD
	 Mnp1j4EUybi2ZqrkAAlfuExBbgyyy2QU15S2swNhUtey4ey+tFKjMK2C7w8yg7SycR
	 s60dLI4UyI5x4z2f33TLsa+wv3AsA4t7EPuMaL8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamalesh Babulal <kamalesh.babulal@oracle.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 209/396] cgroup/cpuset: Fix retval in update_cpumask()
Date: Mon,  1 Apr 2024 17:44:18 +0200
Message-ID: <20240401152554.159062178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Kamalesh Babulal <kamalesh.babulal@oracle.com>

commit 25125a4762835d62ba1e540c1351d447fc1f6c7c upstream.

The update_cpumask(), checks for newly requested cpumask by calling
validate_change(), which returns an error on passing an invalid set
of cpu(s). Independent of the error returned, update_cpumask() always
returns zero, suppressing the error and returning success to the user
on writing an invalid cpu range for a cpuset. Fix it by returning
retval instead, which is returned by validate_change().

Fixes: 99fe36ba6fc1 ("cgroup/cpuset: Improve temporary cpumasks handling")
Signed-off-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org # v6.6+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1948,7 +1948,7 @@ static int update_cpumask(struct cpuset
 	}
 out_free:
 	free_cpumasks(NULL, &tmp);
-	return 0;
+	return retval;
 }
 
 /*


