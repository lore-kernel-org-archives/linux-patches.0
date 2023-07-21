Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58641F946
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4641EC433CB;
	Fri, 21 Jul 2023 16:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956589;
	bh=0bpfjXxrjdiX4FyVhzDO3uQUTNG7OQv3fDvApcD+Cvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrRd5VEdlD8/WcHjw8UWg8YpvYZ6omxM5c9GXNgFKFO+CNiyiL9JeIHTm4ccCSj0U
	 wogJTyaYb+D07/LZIc4/jyKqU190fei1LaGaUftrhaDuV2Xd0xb7GFL8uBeo18J0ea
	 fci4uhMX7sv1fzFVyDo06LXN3oDs6t164bQHCn2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Subject: [PATCH 6.4 230/292] opp: Fix use-after-free in lazy_opp_tables after probe deferral
Date: Fri, 21 Jul 2023 18:05:39 +0200
Message-ID: <20230721160538.742842293@linuxfoundation.org>
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

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

commit b2a2ab039bd58f51355e33d7d3fc64605d7f870d upstream.

When dev_pm_opp_of_find_icc_paths() in _allocate_opp_table() returns
-EPROBE_DEFER, the opp_table is freed again, to wait until all the
interconnect paths are available.

However, if the OPP table is using required-opps then it may already
have been added to the global lazy_opp_tables list. The error path
does not remove the opp_table from the list again.

This can cause crashes later when the provider of the required-opps
is added, since we will iterate over OPP tables that have already been
freed. E.g.:

  Unable to handle kernel NULL pointer dereference when read
  CPU: 0 PID: 7 Comm: kworker/0:0 Not tainted 6.4.0-rc3
  PC is at _of_add_opp_table_v2 (include/linux/of.h:949
  drivers/opp/of.c:98 drivers/opp/of.c:344 drivers/opp/of.c:404
  drivers/opp/of.c:1032) -> lazy_link_required_opp_table()

Fix this by calling _of_clear_opp_table() to remove the opp_table from
the list and clear other allocated resources. While at it, also add the
missing mutex_destroy() calls in the error path.

Cc: stable@vger.kernel.org
Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Fixes: 7eba0c7641b0 ("opp: Allow lazy-linking of required-opps")
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/opp/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1358,7 +1358,10 @@ static struct opp_table *_allocate_opp_t
 	return opp_table;
 
 remove_opp_dev:
+	_of_clear_opp_table(opp_table);
 	_remove_opp_dev(opp_dev, opp_table);
+	mutex_destroy(&opp_table->genpd_virt_dev_lock);
+	mutex_destroy(&opp_table->lock);
 err:
 	kfree(opp_table);
 	return ERR_PTR(ret);


