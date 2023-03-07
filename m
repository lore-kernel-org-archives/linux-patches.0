Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DE8BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F3DC4339B;
	Tue,  7 Mar 2023 19:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215950;
	bh=JJQY/Ti2xaN7vEAA6iPmUdrOR3GvKvs8OkNcl3xKPM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQ0bA1PAEVuX2xV1O7SLrkRGR3Jp1IPP1kyU+IHpVqjSfwOp3oTArbRp5YryUKymz
	 okGi3TAqpt7F9pqluSKrWB8wYZd3GXn8kHKae68BEwsT9dWBWfJEP/YJB+e/E6tC5f
	 /a67btIZJRPSPA9qzH2yqSLP/nm4EV49rQEHB7RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/567] PM: EM: fix memory leak with using debugfs_lookup()
Date: Tue,  7 Mar 2023 18:02:15 +0100
Message-Id: <20230307165923.125129841@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit a0e8c13ccd6a9a636d27353da62c2410c4eca337 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 97e62469a6b32..1b902f986f91c 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -85,10 +85,7 @@ static void em_debug_create_pd(struct device *dev)
 
 static void em_debug_remove_pd(struct device *dev)
 {
-	struct dentry *debug_dir;
-
-	debug_dir = debugfs_lookup(dev_name(dev), rootdir);
-	debugfs_remove_recursive(debug_dir);
+	debugfs_lookup_and_remove(dev_name(dev), rootdir);
 }
 
 static int __init em_debug_init(void)
-- 
2.39.2



