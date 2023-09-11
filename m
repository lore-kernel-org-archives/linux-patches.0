Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79301170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356B1C433C7;
	Mon, 11 Sep 2023 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440354;
	bh=nHk+EUNQOFA2VsrbK0Y86veDQ6rhCio99WOjcLhtcOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZjOIjnBclEiO5x1zBXXs3K8T9b51yonfB6zmNWEbGFUZqMEPSKLzHDEE1qyBdqxX
	 nrEj6kgT8uGK+FUsWIcXXoeLHILbnB3ZI+bsGdrZ/CTTAQ1jQWdT5PZRXI55wSJlU9
	 sebDTCUUvLSe2kARscFf4EP+WOZUtkuxIw211XfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 032/739] selftests/resctrl: Dont leak buffer in fill_cache()
Date: Mon, 11 Sep 2023 15:37:11 +0200
Message-ID: <20230911134651.983780164@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 2d320b1029ee7329ee0638181be967789775b962 ]

The error path in fill_cache() does return before the allocated buffer
is freed leaking the buffer.

The leak was introduced when fill_cache_read() started to return errors
in commit c7b607fa9325 ("selftests/resctrl: Fix null pointer
dereference on open failed"), before that both fill functions always
returned 0.

Move free() earlier to prevent the mem leak.

Fixes: c7b607fa9325 ("selftests/resctrl: Fix null pointer dereference on open failed")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Shaopeng Tan (Fujitsu) <tan.shaopeng@fujitsu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/fill_buf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/resctrl/fill_buf.c b/tools/testing/selftests/resctrl/fill_buf.c
index 341cc93ca84c4..3b328c8448964 100644
--- a/tools/testing/selftests/resctrl/fill_buf.c
+++ b/tools/testing/selftests/resctrl/fill_buf.c
@@ -177,12 +177,13 @@ fill_cache(unsigned long long buf_size, int malloc_and_init, int memflush,
 	else
 		ret = fill_cache_write(start_ptr, end_ptr, resctrl_val);
 
+	free(startptr);
+
 	if (ret) {
 		printf("\n Error in fill cache read/write...\n");
 		return -1;
 	}
 
-	free(startptr);
 
 	return 0;
 }
-- 
2.40.1



