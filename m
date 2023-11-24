Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4492E39FC6;
	Fri, 24 Nov 2023 17:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8rYIjA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74A2C433C8;
	Fri, 24 Nov 2023 17:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848743;
	bh=7Ikk3KIFQCwubPBWlxRF24b1zX/neCi/KcrHix0xkoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8rYIjA/E94iPQbbN0UXEpDpQLYlrYrYGyv7nwYm8qtGWfSlPx+COyDrp3gknjMTC
	 0PhN1xaF7Vrrk3X2U2gjEtMbeAMFYUh0pdcInpWquUYV2xGbAiOOuMLysY8RLjiis1
	 rW+ccowr1FaawAg8fDNE14Bs1O/eWD9qrRC1I938=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Geffon <bgeffon@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 63/97] PM: hibernate: Use __get_safe_page() rather than touching the list
Date: Fri, 24 Nov 2023 17:50:36 +0000
Message-ID: <20231124171936.488348482@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Geffon <bgeffon@google.com>

commit f0c7183008b41e92fa676406d87f18773724b48b upstream.

We found at least one situation where the safe pages list was empty and
get_buffer() would gladly try to use a NULL pointer.

Signed-off-by: Brian Geffon <bgeffon@google.com>
Fixes: 8357376d3df2 ("[PATCH] swsusp: Improve handling of highmem")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/snapshot.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2376,8 +2376,9 @@ static void *get_highmem_page_buffer(str
 		pbe->copy_page = tmp;
 	} else {
 		/* Copy of the page will be stored in normal memory */
-		kaddr = safe_pages_list;
-		safe_pages_list = safe_pages_list->next;
+		kaddr = __get_safe_page(ca->gfp_mask);
+		if (!kaddr)
+			return ERR_PTR(-ENOMEM);
 		pbe->copy_page = virt_to_page(kaddr);
 	}
 	pbe->next = highmem_pblist;
@@ -2557,8 +2558,9 @@ static void *get_buffer(struct memory_bi
 		return ERR_PTR(-ENOMEM);
 	}
 	pbe->orig_address = page_address(page);
-	pbe->address = safe_pages_list;
-	safe_pages_list = safe_pages_list->next;
+	pbe->address = __get_safe_page(ca->gfp_mask);
+	if (!pbe->address)
+		return ERR_PTR(-ENOMEM);
 	pbe->next = restore_pblist;
 	restore_pblist = pbe;
 	return pbe->address;


