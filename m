Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C732A191
	for <patches@lists.linux.dev>; Wed, 14 Dec 2022 00:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670977545; x=1702513545;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BIdIdZncQj9/eXDlCR2brzV8re22T11VTp7foz2HOk8=;
  b=Us+m2/BPCxB4zWWODgEwu7a4162HnNSmKLQyfH0YgsR3mxsAGqP6cTS6
   +f+olBZjsphQWb+pHmH0+vu9t8YM6kD5N6ikOQHQwGCPhD3Xkd5gPTpEr
   hgZ9UgT+cfzGo2MZjWvS4eCvNhODKlab/8/RzTuD+1H3CiQzqsU7d0M+J
   lOa5Apiz56MZpd1UIl+f3ePAsaO7xYRcEH2E+57R8yhYiDha0GJMGNzGN
   vGvJ6c7jVL7fSn7SA0SVsY6dnHDVImDwBcj9sXL61wFOAvNiThup9jKQv
   bpclS+MvUlwfaPWott1O82cxb49yCer+UXoPoo9AKlrrFLTz3nP3UfeBS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="404540179"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="404540179"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="823084742"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="823084742"
Received: from mesplin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.37.170])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 16:25:32 -0800
Subject: [ndctl PATCH 2/5] cxl/filter: enumerate endpoints and memdevs in an
 RCH
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, vishal.l.verma@intel.com,
 patches@lists.linux.dev
Date: Tue, 13 Dec 2022 16:25:32 -0800
Message-ID: <167097753265.1189953.11519741234147002252.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167097752151.1189953.3189708700022130101.stgit@dwillia2-xfh.jf.intel.com>
References: <167097752151.1189953.3189708700022130101.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Vishal Verma <vishal.l.verma@intel.com>

An RCH (Restricted CXL Host) is a platform limited to a smaller subset
of CXL functionality (formerly known as a CXL1.1 platform). Such a
playform may still be able to host a CXL device with a higher spec level
(section 9.11.8 CXL Devices Attached to an RCH in the CXL 3.0
specification).

The caveat with such a configuration is that the endpoints will appear
as 'Root Complex integrated Endpoints' (RCiEPs). In libcxl terms, the
endpoint would be connected directly to the cxl_bus object.

Until now, cxl-list and cxl_filter_walk() assume that endpoints must be
under a cxl_port, which is true for CXL VH topologies. To account for
endpoints in RCH topologies, change cxl_filter_walk() to also account
for endpoints that may appear directly under a cxl_bus object.

With this change, an example CXL RCH topology may enumerate as follows:

    # cxl list -v
    [
      {
        "bus":"root0",
        "provider":"ACPI.CXL",
        "nr_dports":1,
        "dports":[
          {
            "dport":"pci0000:38",
            "id":49
          }
        ],
        "endpoints:root0":[
          {
            "endpoint":"endpoint1",
            "host":"mem0",
            "depth":1,
            "memdev":{
              "memdev":"mem0",
              "pmem_size":0,
              "ram_size":17179869184,
              "serial":0,
              "numa_node":0,
              "host":"0000:38:00.0"
            },
            "decoders:endpoint1":[
              {
                "decoder":"decoder1.0",
                "resource":36507222016,
                "size":17179869184,
                "interleave_ways":1
              }
            ]
          }
        ]
      }
    ]

[djbw: support mixed VH + RCH topologies (cxl_test)]
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/filter.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/cxl/filter.c b/cxl/filter.c
index 8499450ded01..90b13be79d9c 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -1168,6 +1168,14 @@ walk_children:
 		walk_decoders(port, p, pick_array(jchilddecoders, jbusdecoders),
 			      pick_array(jchildregions, jregions), flags);
 
+		dbg(p, "walk rch endpoints\n");
+		if (p->endpoints || p->memdevs || p->decoders)
+			walk_endpoints(port, p,
+				       pick_array(jchildeps, jeps),
+				       pick_array(jchilddevs, jdevs),
+				       pick_array(jchilddecoders, jepdecoders),
+				       flags);
+
 		dbg(p, "walk ports\n");
 		walk_child_ports(port, p, pick_array(jchildports, jports),
 				 pick_array(jchilddecoders, jportdecoders),

