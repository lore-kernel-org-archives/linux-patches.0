Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1406FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059BEC433C8;
	Sun, 17 Sep 2023 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982837;
	bh=pLjZLOEsJDCUsZMyqHU3NQTpJJiTTtv+XoIP1xOTFbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyo7lzQ/w93UcToWrTCKA+pBQc/BUVg2Oz8iqYJVXhmtNrff0Aaz2lpD92OTkBvMQ
	 YoyHvTBXSZAN46YsWKVVrUoWWH7HG8TaebZccsfOAzf96H85CBaRmcVMbvC8QAb6r8
	 XlP+lZ29hCGyjRJXw3l4A03MuZYCa92eHtwwTRJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yu.zhang@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH 5.15 366/511] x86/sgx: Break up long non-preemptible delays in sgx_vepc_release()
Date: Sun, 17 Sep 2023 21:13:13 +0200
Message-ID: <20230917191122.646318550@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wang <jinpu.wang@ionos.com>

commit 3d7d72a34e05b23e21bafc8bfb861e73c86b31f3 upstream.

On large enclaves we hit the softlockup warning with following call trace:

	xa_erase()
	sgx_vepc_release()
	__fput()
	task_work_run()
	do_exit()

The latency issue is similar to the one fixed in:

  8795359e35bc ("x86/sgx: Silence softlockup detection when releasing large enclaves")

The test system has 64GB of enclave memory, and all is assigned to a single VM.
Release of 'vepc' takes a longer time and causes long latencies, which triggers
the softlockup warning.

Add cond_resched() to give other tasks a chance to run and reduce
latencies, which also avoids the softlockup detector.

[ mingo: Rewrote the changelog. ]

Fixes: 540745ddbc70 ("x86/sgx: Introduce virtual EPC for use by KVM guests")
Reported-by: Yu Zhang <yu.zhang@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Yu Zhang <yu.zhang@ionos.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Haitao Huang <haitao.huang@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/sgx/virt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -167,6 +167,7 @@ static int sgx_vepc_release(struct inode
 			continue;
 
 		xa_erase(&vepc->page_array, index);
+		cond_resched();
 	}
 
 	/*
@@ -185,6 +186,7 @@ static int sgx_vepc_release(struct inode
 			list_add_tail(&epc_page->list, &secs_pages);
 
 		xa_erase(&vepc->page_array, index);
+		cond_resched();
 	}
 
 	/*
@@ -206,6 +208,7 @@ static int sgx_vepc_release(struct inode
 
 		if (sgx_vepc_free_page(epc_page))
 			list_add_tail(&epc_page->list, &secs_pages);
+		cond_resched();
 	}
 
 	if (!list_empty(&secs_pages))


